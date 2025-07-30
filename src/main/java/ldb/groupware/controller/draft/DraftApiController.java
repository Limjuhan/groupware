package ldb.groupware.controller.draft;

import jakarta.validation.Valid;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.draft.DraftDeleteDto;
import ldb.groupware.dto.draft.MyDraftSearchDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/draft")
public class DraftApiController {

    private final DraftService draftService;
    private final AttachmentService attachmentService;

    public DraftApiController(DraftService draftService, AttachmentService attachmentService) {
        this.draftService = draftService;
        this.attachmentService = attachmentService;
    }

    @GetMapping("/searchMyDraftList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> searchMyDraftList(
            @SessionAttribute(name = "loginId", required = false) String memId,
            MyDraftSearchDto dto,
            @RequestParam(defaultValue = "1") int page) {

        Map<String, Object> result = draftService.searchMyDraftList(memId, dto, page);
        return ApiResponseDto.ok(result);
    }

    /**
     *  1. **mem_id**로 approval_line에서  1차or2차or참조자로 걸려있는 문서들(doc_id)조회
     *  2. 가져온 **doc_id**로 approval_document에서 제목,양식코드, 내용, 작성자id, 결재상태, 문서종료일  수집(dto에 세팅)
     *  3. approval_line에서 **doc_id**로 1차,2차결재자들의 mem_id 수집
     *  최종: 문서번호(doc_id), 제목(doc_title) 문서양식(form_code), 문서종료일(end_date), 기안자(mem_id), 1차결재자(approval1), 2차결재자(approval2), 결재상태(status)
     * @param dto
     * @param page
     * @return
     */
    @GetMapping("/searchReceivedDraftList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> searchReceivedDraftList(
            MyDraftSearchDto dto,
            @SessionAttribute(name = "loginId", required = false) String memId,
            @RequestParam(defaultValue = "1") int page) {

        Map<String, Object> result = draftService.searchReceivedDraftList(memId, dto, page);
        return ApiResponseDto.ok(result);
    }

    @PostMapping("deleteAttachment")
    public ResponseEntity<ApiResponseDto<Void>> deleteAttachment(
            @RequestParam("savedName") String savedName,
            @RequestParam("attachType") String attachType) {

        try {
            attachmentService.deleteAttachment(List.of(savedName), attachType);
            return ApiResponseDto.successMessage("첨부파일이 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("첨부파일 삭제 중 오류가 발생했습니다.");
        }
    }

    /**
     * 삭제프로세스
     *
     * 임시저장일경우만 삭제.
     *  approval_document
     *  form_양식
     *
     *  첨부파일 존재확인. 존재시 삭제
     *
     * @param dto
     * @return
     */
    @PostMapping("deleteMyDraft")
    public ResponseEntity<ApiResponseDto<Void>> deleteMyDraft(@RequestBody @Valid DraftDeleteDto dto,
                                                              BindingResult br) {

        if (br.hasErrors() || dto.getStatus() != 0 || dto.getDocId() == null) {
            return ApiResponseDto.error("입력값이 유효하지 않습니다.");
        }

        try {
            draftService.deleteMyDraft(dto);
        } catch (RuntimeException e) {
            return ApiResponseDto.error("삭제처리중 오류발생");
        }

        return ApiResponseDto.successMessage("전자결재 삭제 처리 완료.");
    }

}
