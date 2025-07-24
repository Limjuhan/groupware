package ldb.groupware.service.attachment;

import io.micrometer.common.util.StringUtils;
import ldb.groupware.domain.Attachment;
import ldb.groupware.mapper.mybatis.attachment.AttachmentMapper;
import org.jsoup.internal.StringUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

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

        for (MultipartFile file : attachments) {
            if (file.isEmpty()) continue;

            String originalName = file.getOriginalFilename();
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

    public void deleteAttachment(List<String> savedNames) {
        savedNames.forEach(savedName -> {
            attachmentMapper.delete(savedName);
        });
    }
}
