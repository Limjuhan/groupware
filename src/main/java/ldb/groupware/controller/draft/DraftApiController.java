package ldb.groupware.controller.draft;

import jakarta.validation.Valid;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.draft.DraftDeleteDto;
import ldb.groupware.dto.draft.MyDraftSearchDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
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

        return ApiResponseDto.ok(draftService.searchMyDraftList(memId, dto, page));
    }

    @GetMapping("/searchReceivedDraftList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> searchReceivedDraftList(
            MyDraftSearchDto dto,
            @SessionAttribute(name = "loginId", required = false) String memId,
            @RequestParam(defaultValue = "1") int page) {

        return ApiResponseDto.ok(draftService.searchReceivedDraftList(memId, dto, page));
    }

    @PostMapping("deleteAttachment")
    public ResponseEntity<ApiResponseDto<Void>> deleteAttachment(
            @RequestParam("savedName") String savedName,
            @RequestParam("attachType") String attachType) {

        // 예외 발생 시 GlobalExceptionHandler가 처리
        attachmentService.deleteAttachment(List.of(savedName), attachType);
        return ApiResponseDto.successMessage("첨부파일이 성공적으로 삭제되었습니다.");
    }

    @PostMapping("deleteMyDraft")
    public ResponseEntity<ApiResponseDto<Void>> deleteMyDraft(
            @RequestBody @Valid DraftDeleteDto dto) {

        // status 0(임시저장)만 삭제 가능
        if (dto.getStatus() != 0 || dto.getDocId() == null) {
            throw new IllegalArgumentException("입력값이 유효하지 않습니다.");
        }

        draftService.deleteMyDraft(dto);
        return ApiResponseDto.successMessage("전자결재 삭제 처리 완료.");
    }
}
