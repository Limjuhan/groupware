package ldb.groupware.service.attachment;

import io.micrometer.common.util.StringUtils;
import ldb.groupware.domain.Attachment;
import ldb.groupware.mapper.mybatis.attachment.AttachmentMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
public class AttachmentService {

    AttachmentMapper attachmentMapper;

    public AttachmentService(AttachmentMapper attachmentMapper) {
        this.attachmentMapper = attachmentMapper;
    }

    // 파일 업로드 및 Attachment DB저장
    public void saveAttachments(String businessId, String attachType, List<MultipartFile> attachments) {

        if (StringUtils.isBlank(businessId)) {
            throw new IllegalArgumentException("문서ID가 올바르지 않습니다. businessId : " + businessId);
        }

        String uploadDir = getUploadDir(attachType);

        for (MultipartFile file : attachments) {
            if (file.isEmpty()) continue;

            String originalName = file.getOriginalFilename();
            if (originalName == null || !originalName.contains(".")) {
                throw new IllegalArgumentException("유효하지 않은 파일명입니다.");
            }

            String ext = originalName.substring(originalName.lastIndexOf('.') + 1);
            String savedName = UUID.randomUUID().toString() + "." + ext;
            String filePath = "/" + attachType + "/";// DB에 저장될 파일경로Key
            String fileSavePath = uploadDir + savedName; // 프로잭트네 저장경로

            // 웹경로에 첨부파일 저장.
            try {
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                file.transferTo(new File(fileSavePath));
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 실패", e);
            }

            Attachment attach = new Attachment();
            attach.setData(businessId, attachType, originalName, savedName, filePath);

            attachmentMapper.insert(attach);
        }
    }

    private static String getUploadDir(String attachType) {
        String uploadDir = System.getProperty("user.dir");

        if (!StringUtils.isBlank(attachType)) {
            switch (attachType) {
                case "D":
                    uploadDir += "/upload/draft/";
                    break;
                case "N":
                    uploadDir += "/upload/notice/";
                    break;
                case "P":
                    uploadDir += "/upload/profile/";
                    break;
                default:
                    throw new IllegalArgumentException("첨부파일 타입 확인불가");

            }
        }
        return uploadDir;
    }

    public void deleteAttachment(List<String> savedNames, String attachType) {
        if (savedNames == null) {
            throw new IllegalArgumentException("첨부파일리스트가 존재하지않습니다.");
        }

        savedNames.forEach(savedName -> {
            // null이 아니고, 공백만 있는 문자열이 아닌 경우에만 삭제 로직 실행
            if (savedName != null && !savedName.trim().isEmpty()) {
                // 실제 파일도 삭제
                String uploadDir = getUploadDir(attachType);
                String fullPath = uploadDir + File.separator + savedName;
                File file = new File(fullPath);
                if (file.exists()) file.delete();
                // db삭제
                attachmentMapper.delete(savedName);
            } else {
                log.warn("첨부파일 삭제시 빈 내역존재");
            }
        });
    }

    public List<Attachment> getAttachments(String businessId, String attachType) {
        List<Attachment> attachmentList = attachmentMapper.getAttachments(businessId, attachType);

        if (attachmentList == null || attachmentList.isEmpty()) {
            return null;
        }

        for (Attachment a : attachmentList) {
            if (a.getSavedName() == null || a.getFilePath() == null) {
                return null;
            }
        }

        return attachmentList;
    }
}
