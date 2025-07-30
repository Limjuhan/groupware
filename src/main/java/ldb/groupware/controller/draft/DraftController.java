package ldb.groupware.controller.draft;


import jakarta.validation.Valid;
import ldb.groupware.domain.Attachment;
import ldb.groupware.dto.common.CommonConst;
import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.dto.draft.DraftUpdateDto;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    private final CommonService commonService;

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
            @SessionAttribute(name = "loginId", required = false) String memId,
            @RequestParam(value = "formCode", required = false) String formCode,
            Model model) {

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
     * TODO:이용자id, 문서id로 alarm테이블에 insert 단, 임시저장은 저장처리 X. 1차결재자, 참조자만 등록
     *
     * <p>
     * <p>
     * 저장프로세스
     * 1. 임시저장글 -> 임시저장 or 제출
     * -. 임시저장한글 다시 처리시 기존저장했던글 양식과 불일치시 저장불가.
     * <p>
     * 2. 새글 -> 임시저장 or 제출
     * <p>
     * 제출,임시저장 공통
     * -> approval_document : 저장or업데이트
     * -> form_양식정보 : 각양식에맞는 양식테이블 저장or업데이트
     * <p>
     * 제출(action="save")일때만
     * -> approval_line(결재라인)정보 저장.
     * <p>
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
            @SessionAttribute(name = "loginId", required = false) String memId,
            Model model) {

        // 임시저장or제출 2가지 경우가 맞는지 검증
        validateAction(action);
        // 1차,2차,참조자 사원리스트
        List<DraftForMemberDto> memberList = draftService.getMemberList();
        // 잔여 연차조회
        Integer remainAnnual = draftService.getRemainAnnual(memId);
        // 제출시에만 입력값 검증
        if ("save".equals(action)) {
            // 결재자 중복체크
            validateApproval(dto);
            // 추가 유효성 검증 (양식별 필드)
            validFormType(dto, bindingResult);

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

    private void validateApproval(DraftFormDto dto) {
        String approver1 = dto.getApprover1();
        String approver2 = dto.getApprover2();
        List<String> referrers = dto.getReferrerList();

        // 1. 필수값 체크
        if (StringUtils.isBlank(approver1)) {
            throw new IllegalStateException("1차 결재자를 선택하세요.");
        }
        if (StringUtils.isBlank(approver2)) {
            throw new IllegalStateException("2차 결재자를 선택하세요.");
        }

        // 2. 1차/2차 결재자 중복 방지
        if (approver1.equals(approver2)) {
            throw new IllegalStateException("1차 결재자와 2차 결재자가 같을 수 없습니다.");
        }

        // 3. 참조자 목록이 비어있지 않을 때만 체크
        if (referrers != null && !referrers.isEmpty()) {
            for (String ref : referrers) {
                if (approver1.equals(ref)) {
                    throw new IllegalStateException("참조자 목록에 1차 결재자가 포함될 수 없습니다.");
                }
                if (approver2.equals(ref)) {
                    throw new IllegalStateException("참조자 목록에 2차 결재자가 포함될 수 없습니다.");
                }
            }
        }
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
            case "app_01" -> { // 휴가계획서
                if (dto.getLeaveStart() == null || dto.getLeaveEnd() == null || StringUtils.isBlank(dto.getLeaveCode())) {
                    bindingResult.reject("leave.required", "휴가 유형 및 기간은 필수입니다.");
                } else if (dto.getLeaveEnd().isBefore(dto.getLeaveStart())) {
                    bindingResult.reject("leave.date.invalid", "휴가 종료일은 시작일 이후여야 합니다.");
                }
            }
            case "app_02" -> { // 프로젝트 제안서
                if (StringUtils.isBlank(dto.getProjectName()) || dto.getProjectStart() == null || dto.getProjectEnd() == null) {
                    bindingResult.reject("project.required", "프로젝트 이름과 기간 입력은 필수입니다.");
                } else if (dto.getProjectEnd().isBefore(dto.getProjectStart())) {
                    bindingResult.reject("project.date.invalid", "프로젝트 종료일은 시작일 이후여야 합니다.");
                }
            }
            case "app_03" -> { // 지출결의서
                if (dto.getExAmount() == null || StringUtils.isBlank(dto.getExName())) {
                    bindingResult.reject("expense.required", "지출 항목 및 금액은 필수입니다.");
                }
            }
            case "app_04" -> { // 사직서
                if (dto.getResignDate() == null) {
                    bindingResult.reject("resign.required", "사직일 선택은 필수입니다.");
                }
            }
            default -> bindingResult.reject("error.formtype.missing");
        }
    }


    /**
     *TODO:이용자id, 문서id로 alarm테이블에 row존재하는지 확인하여 readYn='Y' 업데이트
     *
     * @param model
     * @return draft/draftDetail
     */
    @GetMapping("/getMyDraftDetail")
    public String getMyDraftDetail(DraftFormDto dto, Model model) {

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

    /**
     * TODO:이용자id, 문서id로 alarm테이블에 row존재하는지 확인하여 readYn='Y' 업데이트
     *
     * 참조자 : 승인,반려버튼 안보이고 클릭시 클릭한유저에대한 검증 필요
     * 1차결재자 : 1차결재대기상태일때만 승인or반려버튼 조회가능.클릭시 클릭한유저에대한 검증 필요
     * 2차결재자: 2차결재대기일때만 승인or반려버튼 조회가능.클릭시 클릭한유저에대한 검증 필요
     *
     *
     * @param dto
     * @param memId
     * @param model
     * @return
     */
    @GetMapping("receivedDraftDetail")
    public String getReceivedDraftDetail(DraftFormDto dto,
                                         @SessionAttribute(name = "loginId", required = false) String memId,
                                         Model model) {

        try {
            if (dto.getDocId() == null) {
                throw new IllegalArgumentException("문서가 존재하지 않습니다.");
            }

            // 현재 잔여연차 조회
            Integer remainAnnual = draftService.getRemainAnnual(memId);

            // 문서 상세 정보 조회
            DraftFormDto draftInfo = draftService.getMyDraftDetail(dto);

            // 첨부파일조회
            Optional<List<Attachment>> optionalAttachmentList =
                    attachmentService.getAttachments(dto.getDocId().toString(), dto.getAttachType());

            model.addAttribute("remainDays", remainAnnual);
            model.addAttribute("draftDetail", draftInfo);
            optionalAttachmentList.ifPresent(attachments -> {
                model.addAttribute("attachments", attachments);
            });
        } catch (RuntimeException e) {
            model.addAttribute("globalError", e.getMessage());
        } finally {
            return "draft/receivedDraftDetail";
        }

    }

    /**
     * 결재자-> 승인or반려
     *
     * 1.차결재대기
     *  -> 세션에서 가져온 id와 해당문서의 1차결재자id가 동일한지 검증
     *
     *  -> approval_document의 status 4(2차결재대기)로 변경
     *     approval_line의 1차결재자id(memId)기준 comment 업데이트
     *     approval_line에서 docId기준 status값 4로 일괄 업데이트
     *     alarm테이블 2차결재자, 기안자 insert. 참조자는 readYn='Y' update
     *
     * 2.차결재대기
     *  -> 세션에서 가져온 id와 해당문서의 2차결재자id가 동일한지 검증
     *
     *  -> 연차관련 2차결재승인시에는 annual_leave에서 남은연차일수(remainDays) 차감해줘야됨.
     *     수정일시는 현재시간, 수정자는 2차결재담당자
     *
     *     approval_document의 status 4(2차결재대기)로 변경
     *
     *
     * @param dto
     * @param memId
     * @param redirectAttributes
     * @return
     */
    @GetMapping("updateDraft")
    public String updateDraft(DraftUpdateDto dto,
                              @SessionAttribute(name = "loginId") String memId,
                              RedirectAttributes redirectAttributes) {

        if ("approve".equals(dto.getAction())) {
            draftService.approveDraft(dto, memId);
            redirectAttributes.addFlashAttribute("message", "결재 승인");
        } else if ("reject".equals(dto.getAction())) {
            draftService.rejectDraft(dto, memId);
            redirectAttributes.addFlashAttribute("message", "결재 반려");
        }
        return "redirect:/draft/receivedDraftList";
    }

    // 결재대기상태 공통코드 조회
    private List<CommonTypeDto> getApprovalStatusList() {
        return commonService.getCommonTypesByGroup(CommonConst.APPROVAL_STATUS.getValue());
    }
}
