package ldb.groupware.controller.draft;

import io.micrometer.common.util.StringUtils;
import jakarta.validation.Valid;
import ldb.groupware.domain.Attachment;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Slf4j
@Controller
@RequestMapping("/draft")
public class DraftController {

    private final DraftService draftService;
    private final MessageSource messageSource;
    private final AttachmentService attachmentService;

    public DraftController(DraftService draftService, MessageSource messageSource, AttachmentService attachmentService) {
        this.draftService = draftService;
        this.messageSource = messageSource;
        this.attachmentService = attachmentService;
    }

    @GetMapping("getMyDraftList")
    public String getMyDraftList() {
        return "draft/draftList";
    }

    @GetMapping("draftForm")
    public String draftForm(
            @RequestParam(value = "docId", required = false) Integer docId,
            @RequestParam(value = "memId", required = false) String memId,
            @RequestParam(value = "formCode", required = false) String formCode,
            Model model) {

        // 세션 또는 고정 아이디 (테스트용)
        if (memId == null) {
            memId = "user008";
        }

        // 연차 정보 및 결재자 목록 조회
        Integer remainAnnual = draftService.getRemainAnnual(memId);
        List<DraftForMemberDto> memberList = draftService.getMemberList();

        // 임시저장 문서 불러오기 또는 빈 DTO 생성
        DraftFormDto dto = null;
        try {
            if (docId != null && StringUtils.isNotBlank(formCode)) {
                dto = draftService.getDraftForm(docId, formCode);

                Optional<List<Attachment>> optionalAttachmentList =
                        attachmentService.getAttachments(docId.toString(), dto.getAttachType());

                // NPE 방지
                optionalAttachmentList.ifPresent(attachments -> {
                    model.addAttribute("attachments", attachments);
                });
            } else {
                dto = new DraftFormDto();
            }
        } catch (Exception e) {
            model.addAttribute("globalError", e.getMessage());
        } finally {
            model.addAttribute("draftFormDto", dto);
            model.addAttribute("draftMembers", memberList);
            model.addAttribute("remainAnnual", remainAnnual);

            return "draft/draftForm";
        }
    }

    /**
     * @param dto
     * @param bindingResult
     * @param attachments
     * @param action
     * @param memId
     * @param model
     * @return
     */
    @PostMapping("insertMyDraft")
    public String insertMyDraft(
            @Valid @ModelAttribute("draftFormDto") DraftFormDto dto,
            BindingResult bindingResult,
            @RequestParam(value = "attachments", required = false) List<MultipartFile> attachments,
            @RequestParam(value = "action", required = false) String action,
            @SessionAttribute(name = "memId", required = false) String memId,
            Model model) {

        validateAction(action);
        // 임시 하드코딩
        memId = "user008";
        // 1차,2차,참조자 사원리스트
        List<DraftForMemberDto> memberList = draftService.getMemberList();
        // 제출시에만 입력값 검증
        if ("save".equals(action)) {
            validFormType(dto, bindingResult);// 추가 유효성 검증 (양식별 필드)
            if (bindingResult.hasErrors()) {
                model.addAttribute("draftMembers", draftService.getMemberList());
                return "draft/draftForm";
            }
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

        private void validateAction (String action){
            if (!"save".equals(action) && !"temporary".equals(action)) {
                throw new IllegalArgumentException(
                        messageSource.getMessage("error.action.invalid", null, Locale.KOREA)
                );
            }
        }

        private void validFormType (DraftFormDto dto, BindingResult bindingResult){

            switch (dto.getFormCode()) {
                case "app_01" -> {
                    if (dto.getLeaveStart() == null || dto.getLeaveEnd() == null || StringUtils.isBlank(dto.getLeaveCode())) {
                        bindingResult.reject("leave.required", "휴가 유형 및 기간은 필수입니다.");
                    }
                }
                case "app_02" -> {
                    if (StringUtils.isBlank(dto.getProjectName()) || dto.getProjectStart() == null || dto.getProjectEnd() == null) {
                        bindingResult.reject("project.required", "프로젝트 이름or기간입력은 필수입니다.");
                    }
                }
                case "app_03" -> {
                    if (dto.getExAmount() == null || StringUtils.isBlank(dto.getExName())) {
                        bindingResult.reject("expense.required", "지출 항목 및 금액은 필수입니다.");
                    }
                }
                case "app_04" -> {
                    if (dto.getResignDate() == null) {
                        bindingResult.reject("resign.required", "사직일 선택은 필수입니다.");
                    }
                }
                default -> bindingResult.reject("error.formtype.missing");
            }
        }

/**
 * 연차상세정보 불러오기
 * 조회목록 : 문서번호 ,양식 , 제목, 기안자 , 상태 ,
 * 1차결재자 , 2차결재자 , 문서종료일 , 첨부파일 , 본문내용,양식정보
 * 첨부파일리스트 가져오기
 *
 * @param docId
 * @param memId
 * @param model
 * @return draft/draftDetail
 */
        @GetMapping("/getMyDraftDetail")
        public String getMyDraftDetail (@RequestParam("docId") Integer docId,
                @RequestParam("memId") String memId,
                Model model){
            // 문서 상세 정보 조회
//        DraftDetailDto detail = draftService.getDraftDetail(docId, memId);

//        model.addAttribute("draftDetail", detail);
            return "draft/draftDetail"; // 출력할 JSP 페이지 경로
        }

        @GetMapping("receivedDraftList")
        public String receivedDraftList () {
            return "draft/receivedDraftList";
        }
    }
