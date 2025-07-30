package ldb.groupware.service.board;

import ldb.groupware.domain.Attachment;
import ldb.groupware.domain.QnaComment;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.board.*;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.attachment.AttachmentMapper;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import ldb.groupware.mapper.mybatis.board.QnaMapper;
import ldb.groupware.service.attachment.AttachmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.HandlerMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class QnaService {
    private final QnaMapper mapper;
    private final FaqMapper faqMapper;
    private final AttachmentService attachmentService;
    private final AttachmentMapper  attachmentMapper;
    private final HandlerMapping resourceHandlerMapping;


    public Map<String, Object> getQnaList(PaginationDto paging) {
        HashMap<String, Object> map = new HashMap<>();
        int count = mapper.countQna();
        paging.setTotalRows(count);
        paging.calculatePagination();
        List<QnaListDto> list = mapper.getQnaList(paging);
        List<FaqListDto> faq = faqMapper.findList(5); //상위5개의 자주묻는질문만가져와;
        map.put("pageDto", paging);
        map.put("qna", list);
        map.put("faq", faq);
        return map;
    }

    public boolean insertQna(QnaFormDto dto , List<MultipartFile> files) {
        AttachmentDto attach = new AttachmentDto();

        if(mapper.insertQna(dto)>0) {
            int maxId = mapper.maxQnaId(dto.getMemId());
            String businessId = String.valueOf(maxId); //insert한 질문게시판 글의   (String)qna_id
            attachmentService.saveAttachments(businessId , "Q", files);
            return true;
        }
        System.out.println("등록실패(service)");
        return false;
    }

    public  Map<String,Object> findDetailById(int id) {
        System.out.println("findById서비스 접근");
        HashMap<String, Object> map = new HashMap<>();
        QnaDetailDto qnaDto = mapper.findQnaById(id);

        //mem_id가 business에존재해서 varchar타입임
        String businessId = String.valueOf(id);
        Optional<List<Attachment>> attach = attachmentService.getAttachments(businessId, "Q");
        attach.ifPresent(list -> map.put("attachments", list));

        mapper.addViewCount(id);
        qnaDto.formatDates();
        System.out.println("qnaDto :::: "+qnaDto);
        map.put("qna", qnaDto);
        return map;
    }

    public boolean insertComment(CommentFormDto dto) {
        if(mapper.insertComment(dto)>0){
            return true;
        }
        return false;
    }

    public List<QnaComment> findCommentById(int qnaId) {
       return  mapper.findCommById(qnaId);
    }

    public boolean updateQna( QnaUpdateDto dto, List<MultipartFile> files) {
        AttachmentDto attach = new AttachmentDto();
        String businessId = String.valueOf(dto.getQnaId());
        System.out.println("dto.getQnaId : "+dto.getQnaId());
        System.out.println("businessId : "+businessId);
      if(mapper.updateQna(dto) > 0 ){
          List<String> existingFiles = dto.getExistingFiles();
          if(existingFiles!=null && !existingFiles.isEmpty()) {
              attachmentService.deleteAttachment(existingFiles,"Q");
          }
          attachmentService.saveAttachments(businessId, "Q", files);
          return true;
      }
      return false;
    }


    public boolean deleteById(int id) {
        if(mapper.deleteById(id)>0){
            return true;
        }
        return false;
    }

    public boolean deleteCommentById(int id) {
        if(mapper.deleteCommentById(id)>0){
            return true;
        }
        return false;
    }
}
