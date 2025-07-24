package ldb.groupware.controller.draft;

import io.micrometer.common.util.StringUtils;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

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
    public String draftForm(Model model, HttpSession session) {

        String memId = "user008";
        Integer remainAnnual = draftService.getRemainAnnual(memId);
        List<DraftForMemberDto> memberList = draftService.getMemberList();

        model.addAttribute("draftMembers", memberList);
        model.addAttribute("remainAnnual", remainAnnual);
        model.addAttribute("draftFormDto", new DraftFormDto());

        return "draft/draftForm";
    }

    @PostMapping("insertMyDraft")
    public String insertMyDraft(
            @Valid @ModelAttribute("draftFormDto") DraftFormDto dto,
            BindingResult bindingResult,
            @RequestParam(value = "attachments", required = false) List<MultipartFile> attachments,
            @RequestParam(value = "action", required = false) String action,
            @SessionAttribute(name = "memId", required = false) String memId,
            Model model) {

        memId = "user008";
        // 추가 유효성 검증 (양식별 필드)
        validFormType(dto, bindingResult);
        // 1차,2차,참조자 사원리스트
        List<DraftForMemberDto> memberList = draftService.getMemberList();

        if (bindingResult.hasErrors()) {
            model.addAttribute("draftMembers", memberList);
            return "draft/draftForm";
        }

        try {
            draftService.saveDraft(dto, attachments, action, memId);
        } catch (Exception e) {
            model.addAttribute("globalError", e.getMessage());
            model.addAttribute("draftMembers", memberList);
            return "draft/draftForm";
        }

        return "redirect:/draft/getMyDraftList";
    }

    private void validFormType(DraftFormDto dto, BindingResult bindingResult) {

        if ("app_01".equals(dto.getFormType())) {
            if (dto.getLeaveStart() == null || dto.getLeaveEnd() == null || StringUtils.isBlank(dto.getLeaveType())) {
                bindingResult.reject("leave.required", "휴가 유형 및 기간은 필수입니다.");
            }
        } else if ("app_02".equals(dto.getFormType())) {
            if (StringUtils.isBlank(dto.getProjectTitle()) || StringUtils.isBlank(dto.getExpectedDuration())) {
                bindingResult.reject("project.required", "프로젝트 정보는 필수입니다.");
            }
        } else if ("app_03".equals(dto.getFormType())) {
            if (dto.getAmount() == null || StringUtils.isBlank(dto.getExpenseItem())) {
                bindingResult.reject("expense.required", "지출 항목 및 금액은 필수입니다.");
            }
        } else if ("app_04".equals(dto.getFormType())) {
            if (dto.getResignDate() == null) {
                bindingResult.reject("resign.required", "사직일 선택은 필수입니다.");
            }
        }
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
