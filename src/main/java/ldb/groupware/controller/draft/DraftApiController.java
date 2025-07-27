package ldb.groupware.controller.draft;

import io.micrometer.common.util.StringUtils;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Set;

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
            @RequestParam String type,
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int page) {

        // 로그인 사용자 ID (임시 하드코딩)
        String memId = "user008";

        Map<String, Object> result = draftService.searchMyDraftList(memId, type, keyword, page);
        result.forEach((k, v) -> System.out.println("[전자결재리스트조회] " + k + " : " + v));

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

}
