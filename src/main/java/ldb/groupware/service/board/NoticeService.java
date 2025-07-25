package ldb.groupware.service.board;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.*;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.mapper.mybatis.board.NoticeMapper;
import ldb.groupware.service.attachment.AttachmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NoticeService {


    private  final  NoticeMapper mapper;
    private final AttachmentService attachService;



    public Map<String, Object> getNoticeList(PaginationDto pageDto) {
        HashMap<String, Object> map = new HashMap<>();
        List<NoticeListDto> pinnedList = mapper.getPinnedList(pageDto);


        int pinnedCount = mapper.pinnedCount();
        int count = mapper.noticeCount(); //공지사항(상단고정X)의 갯수
      pageDto.setTotalRows(count);
        pageDto.setItemsPerPage(pageDto.getItemsPerPage()-pinnedCount); //10개 - 고정된 핀 갯수만 출력
      pageDto.calculatePagination(); //보여줄 페이지의갯수 , 페이지당 제한갯수 등 설정


        System.out.println("pageDto : "+pageDto);
        List<NoticeListDto> dto = mapper.getNoticeList(pageDto);

        for (NoticeListDto dto1 : dto) {
            dto1.updatedAtToString(); //LocalDateTime-->String 변환
        }
        for (NoticeListDto dto2 : pinnedList) {
            dto2.updatedAtToString();
        }
        System.out.println("getNoticeListDto :: "+dto);
        map.put("pinnedList", pinnedList);
        map.put("notice", dto);
        map.put("pageDto", pageDto);
        return map;
    }



    public boolean insertNotice(NoticeFormDto dto, List<MultipartFile> files) {
        AttachmentDto attach = new AttachmentDto();
        mapper.insertNotice(dto);
        int noticeId  = mapper.getMaxNum(dto.getMemId());
        String noId = String.valueOf(noticeId);
        attachService.saveAttachments(noId,"N",files);
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
        map.put("notice", notice);
        if(attach!=null && attach.size()>0){
            map.put("attach", attach);
        }
        return map;
    }

    //파일삭제 서비스
    public void deleteFile(String[] existingFiles) {
        for (String file : existingFiles) {
            mapper.deleteFile(file);
        }
    }

    public boolean updateNotice(List<MultipartFile> files, NoticeUpdateDto dto) {
        AttachmentDto attach = new AttachmentDto();
        String noId = String.valueOf(dto.getNoticeId());
        if(mapper.updateNotice(dto)>0){
            List<String> existingFiles = dto.getExistingFiles();
            if(existingFiles!=null && existingFiles.size()>0) {
               attachService.deleteAttachment(existingFiles,"N");
            }
            attachService.saveAttachments(noId,"N",files);
            return true;
        }
        else{
            return  false;
        }
    }

    public void plusCnt(String id) {
        mapper.plusCnt(id);
    }

    public boolean deleteNotice(String id) {
        Integer noticeId = Integer.valueOf(id);
        if(mapper.deleteNotice(noticeId)>0){
            return true;
        }
        else{
            return false;
        }
    }
}
