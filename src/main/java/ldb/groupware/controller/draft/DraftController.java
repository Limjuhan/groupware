package ldb.groupware.controller.draft;


import jakarta.validation.Valid;
import ldb.groupware.domain.Attachment;
import ldb.groupware.dto.common.CommonConst;
import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.common.CommonService;
import ldb.groupware.service.draft.DraftService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
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
    private final CommonService  commonService;

    public DraftController(DraftService draftService, MessageSource messageSource, AttachmentService attachmentService, CommonService commonService) {
        this.draftService = draftService;
        this.messageSource = messageSource;
        this.attachmentService = attachmentService;
        this.commonService = commonService;
    }

    @GetMapping("getMyDraftList")
    public String getMyDraftList(Model model) {
        List<CommonTypeDto> approvalStatusList = getApprovalStatusList();

        model.addAttribute("approvalStatusList", approvalStatusList);
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
     * TODO: 알람테이블 저장 처리 아직 안함.
     * 저장프로세스
     * 1. 임시저장글 -> 임시저장 or 제출
     *  -. 임시저장한글 다시 처리시 기존저장했던글 양식과 불일치시 저장불가.
     *
     * 2. 새글 -> 임시저장 or 제출
     *
     * 제출,임시저장 공통
     * -> approval_document : 저장or업데이트
     * -> form_양식정보 : 각양식에맞는 양식테이블 저장or업데이트
     *
     * 제출(action="save")일때만
     * -> approval_line(결재라인)정보 저장.
     *
     * 기본적으로 임시저장은 입력값 유효성검사 제외.
     * 단, 휴가계획서는 임시저장할때도 휴가시작,끝나는날 필수입력받음.
     *
     * @param dto
     * @param bindingResult
     * @param attachments
     * @param action
     * @param savedFormCode
     * @param model
     * @return
     */
    @PostMapping("insertMyDraft")
    public String insertMyDraft(
            @Valid @ModelAttribute("draftFormDto") DraftFormDto dto,
            BindingResult bindingResult,
            @RequestParam(value = "attachments", required = false) List<MultipartFile> attachments,
            @RequestParam(value = "action", required = false) String action,
            @RequestParam(value = "savedFormCode", required = false) String savedFormCode,
            Model model) {

        System.out.println("임시저장시 데이터 확인" + action);
        validateAction(action);
        // 임시 하드코딩
        String memId = "user008";
        // 1차,2차,참조자 사원리스트
        List<DraftForMemberDto> memberList = draftService.getMemberList();
        // 잔여 연차조회
        Integer remainAnnual = draftService.getRemainAnnual(memId);
        // 제출시에만 입력값 검증
        if ("save".equals(action)) {
            validFormType(dto, bindingResult);// 추가 유효성 검증 (양식별 필드)
            if (bindingResult.hasErrors()) {
                model.addAttribute("draftMembers", draftService.getMemberList());
                model.addAttribute("remainAnnual", remainAnnual);
                return "draft/draftForm";
            }
        }

        try {
            draftService.saveDraft(dto, attachments, action, memId, savedFormCode);
        } catch (Exception e) {
            model.addAttribute("globalError", e.getMessage());
            model.addAttribute("draftMembers", memberList);
            model.addAttribute("remainAnnual", remainAnnual);
            return "draft/draftForm";
        }

        return "redirect:/draft/getMyDraftList";
    }

    private void validateAction(String action) {
        if (!"save".equals(action) && !"temporary".equals(action)) {
            throw new IllegalArgumentException(
                    messageSource.getMessage("error.action.invalid", null, Locale.KOREA)
            );
        }
    }

    private void validFormType(DraftFormDto dto, BindingResult bindingResult) {

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
     *
     * @param memId
     * @param model
     * @return draft/draftDetail
     */
    @GetMapping("/getMyDraftDetail")
    public String getMyDraftDetail(DraftFormDto dto,
                                   @RequestParam("memId") String memId,
                                   Model model) {

        try {
            if (dto.getDocId() == null) {
                throw new IllegalArgumentException("문서가 존재하지 않습니다.");
            }

            // 문서 상세 정보 조회
            DraftFormDto draftInfo = draftService.getMyDraftDetail(dto);
            // 첨부파일조회
            Optional<List<Attachment>> optionalAttachmentList =
                    attachmentService.getAttachments(dto.getDocId().toString(), dto.getAttachType());


            model.addAttribute("draftDetail", draftInfo);
            optionalAttachmentList.ifPresent(attachments -> {
                model.addAttribute("attachments", attachments);
            });
        } catch (RuntimeException e) {
            model.addAttribute("globalError", e.getMessage());
        } finally {
            return "draft/draftDetail";
        }

    }

    @GetMapping("receivedDraftList")
    public String receivedDraftList(Model model) {
        List<CommonTypeDto> approvalStatusList = getApprovalStatusList();

        model.addAttribute("approvalStatusList", approvalStatusList);
        return "draft/receivedDraftList";
    }

    // 결재대기상태 공통코드 조회
    private List<CommonTypeDto> getApprovalStatusList() {
        return commonService.getCommonTypesByGroup(CommonConst.APPROVAL_STATUS.getValue());
    }
}
