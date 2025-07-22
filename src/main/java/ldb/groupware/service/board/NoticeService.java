package ldb.groupware.service.board;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.AttachUpdateDto;
import ldb.groupware.dto.board.NoticeDetailDto;
import ldb.groupware.dto.board.NoticeFormDto;
import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.mapper.mybatis.board.NoticeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class NoticeService {

    @Autowired
    private  NoticeMapper mapper;

    public Map<String, Object> getNoticeList(PaginationDto pageDto) {
        HashMap<String, Object> map = new HashMap<>();
        int count = mapper.noticeCount(); //공지사항의 전체 row 갯수
      pageDto.setTotalRows(count);
      pageDto.calculatePagination(); //보여줄 페이지의갯수 , 페이지당 제한갯수 등 설정
        System.out.println("pageDto : "+pageDto);
        List<NoticeListDto> dto = mapper.getNoticeList(pageDto);
        for (NoticeListDto dto1 : dto) {
            dto1.updatedAtToString(); //LocalDateTime-->String 변환
        }

        System.out.println("getNoticeListDto :: "+dto);
        map.put("notice", dto);
        map.put("pageDto", pageDto);
        return map;
    }

    private String uploadFileCreate(MultipartFile file, String path) {
        String name = file.getOriginalFilename();
        String extension = name.substring(name.lastIndexOf("."));
        String orgFile = UUID.randomUUID().toString()+extension;
        File f = new File(path);
        if(!f.exists()) {
            f.mkdirs();
        }
        try {
            file.transferTo(new File(path+orgFile));
            return orgFile;
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertNotice(NoticeFormDto dto, List<MultipartFile> files
            , HttpServletRequest request) {
        AttachmentDto attach = new AttachmentDto();
        mapper.insertNotice(dto);
        int noticeId  = mapper.getMaxNum(dto.getMemId());
        String noId = String.valueOf(noticeId);

        for (MultipartFile file : files) {
            if(file!=null && !file.isEmpty()) {
                //String path = request.getServletContext().getRealPath("/")+"board/file/";
                String uploadDir = System.getProperty("user.dir") + "/upload/notice/";
                String savedName = this.uploadFileCreate(file, uploadDir);
                attach.setAttachType("N");
                String originalFilename = file.getOriginalFilename();
                attach.setSavedName(savedName); // saveName
                attach.setFilePath("/N/"); // 경로 + saveName
                attach.setOriginalName(originalFilename); //원본이름
                attach.setBusinessId(noId);
                mapper.insertAttach(attach);
            }
        }
        return true;
    }

    public String getMember(String id) {
        String name = mapper.getMember(id);
        return name;
    }

    public Map<String, Object> getNoticeById(String id) {
        HashMap<String, Object> map = new HashMap<>();
        NoticeDetailDto notice = mapper.getNoticeById(id);
        List<AttachmentDto> attach = mapper.getAttachByNoticeId(id);
        //System.out.println("noticeById :: "+notice);
        //System.out.println("attach :: "+attach);
        map.put("notice", notice);
        map.put("attach", attach);
        return map;
    }

    //파일삭제 서비스
    public void deleteFile(String[] existingFiles, String businessId) {
        for (String file : existingFiles) {
            AttachUpdateDto attach = new AttachUpdateDto();
            attach.setFileName(file);
            attach.setBusinessId(businessId);
            mapper.deleteFile(attach);
        }
    }
}
