package ldb.groupware.controller.draft;

import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/draft")
public class DraftController {

    private final DraftService dService;

    public DraftController(DraftService dService) {
        this.dService = dService;
    }

    @GetMapping("getMyDraftList")
    public String getMyDraftList() {
        return "draft/draftList";
    }

    @GetMapping("draftDetail")
    public String draftDetail() {
        return "draft/draftDetail";
    }

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
