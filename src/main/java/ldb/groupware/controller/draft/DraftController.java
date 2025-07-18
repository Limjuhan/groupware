package ldb.groupware.controller.draft;

import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/draft")
public class DraftController {

    private final DraftService draftService;

    public DraftController(DraftService draftService) {
        this.draftService = draftService;
    }

    @GetMapping("getMyDraftList")
    public String getMyDraftList() {
        return "draft/draftList";
    }

//    @GetMapping("getMyDraftDetail")
//    public String draftDetail(@RequestParam String docId,
//                              @RequestParam String writerId,
//                              Model model) {
//        /*
//         연차상세정보 불러오기
//         조회목록 : 문서번호 ,양식 , 제목, 기안자 , 상태 ,
//        1차결재자 , 2차결재자 , 문서종료일 , 첨부파일 , 본문내용,양식정보
//         첨부파일리스트 가져오기
//         */
//        draftService.getMyDraft(docId, writerId);
//        draftService.getMyannualInfo(docId, writerId);
//
//        return "draft/draftDetail";
//    }

    @GetMapping("draftForm")
    public String draftForm() {
        return "draft/draftForm";
    }



    @GetMapping("draftManagement")
    public String draftManagement() {
        return "draft/receivedDraftDetail";
    }

    @GetMapping("receivedDraftList")
    public String receivedDraftList() {
        return "draft/receivedDraftList";
    }


}
