package ldb.groupware.controller.draft;

import io.micrometer.common.util.StringUtils;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    public List<DraftListDto> searchMyDraftList(@RequestParam String type,
                                                @RequestParam String keyword,
                                                HttpSession session) {

        List<DraftListDto> draftList = null;
//        String memId = session.getAttribute("memId").toString();
        String memId = "user008";

        // 검색조건 없으면 전체 조회
        if (StringUtils.isBlank(type) || StringUtils.isBlank(keyword)) {
            draftList = draftService.searchMyDraftList(memId, null, null);
        } else {
            draftList = draftService.searchMyDraftList(memId, type, keyword);
        }

        draftList.forEach(draftListDto -> {
            System.out.println("draftListDto = " + draftListDto);
        });

        return draftList;
    }

    @PostMapping("delete")
    public ResponseEntity<?> deleteAttachment(
            @RequestParam("savedName") String savedName,
            @RequestParam("attachType") String attachType) {
        try {
            attachmentService.deleteAttachment(List.of(savedName), attachType);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error");
        }
    }

}
