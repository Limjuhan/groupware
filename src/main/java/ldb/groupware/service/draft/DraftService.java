package ldb.groupware.service.draft;

import io.micrometer.common.util.StringUtils;
import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.domain.FormExpense;
import ldb.groupware.domain.FormProject;
import ldb.groupware.domain.FormResign;
import ldb.groupware.dto.draft.ApprovalConst;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.mapper.mapstruct.ConvertDtoMapper;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import ldb.groupware.service.attachment.AttachmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Locale;

@Slf4j
@Service
public class DraftService {

    private final DraftMapper draftMapper;
    private final AttachmentService attachmentService;
    private final ConvertDtoMapper convertDtoMapper;
    private final MessageSource messageSource;

    public DraftService(DraftMapper draftMapper, AttachmentService attachmentService, ConvertDtoMapper convertDtoMapper, MessageSource messageSource) {
        this.draftMapper = draftMapper;
        this.attachmentService = attachmentService;
        this.convertDtoMapper = convertDtoMapper;
        this.messageSource = messageSource;
    }

    public List<DraftListDto> searchMyDraftList(String memId, String type, String keyword) {
        return draftMapper.getMyDraftList(memId, type, keyword);
    }

    public List<DraftForMemberDto> getMemberList() {
        return draftMapper.getMemberList();
    }

    public Integer getRemainAnnual(String memId) {
        return draftMapper.getRemainAnnual(memId);
    }

    /**
     * TODO: 연차생성관련 배치프로세스 정리하기
     * 최초 상신시 : attachment, approval_document, approval_line
     *              form_annual_leave, form_expense, form_resign, annual_leave_history
     *
     * @param dto
     * @param attachments
     * @param action
     * @param memId
     *
     */
    @Transactional
    public void saveDraft(DraftFormDto dto, List<MultipartFile> attachments, String action, String memId) throws IllegalArgumentException {

        int status = getStatus(action);

        if (StringUtils.isNotBlank(dto.getDocId().toString())) { // 임시저장 -> 임시저장 or 제출
            updateApprovalDraft(dto, memId, status);
        } else if (StringUtils.isBlank(dto.getDocId().toString())) { // 새글작성->임시저장 or 제출
            insertNewApprovalDraft(dto, memId, status);
        } else {
            throw new IllegalArgumentException(
                    messageSource.getMessage("error.docid.invalid", null, Locale.KOREA));
        }

        if (action.equals("save")) {// 새글작성 -> 제출
            saveApprovalLine(dto); // 결재선 저장
        }

        attachmentService.saveAttachments(dto.getDocId().toString(), dto.getAttachType(), attachments);
    }

    private void updateFormDetail(DraftFormDto dto, String memId, int status) {
        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                validateAnnualLeave(dto, memId);
                draftMapper.updateFormAnnualLeave(FormAnnualLeave.from(dto));
            }
            case ApprovalConst.FORM_PROJECT -> draftMapper.updateFormProject(FormProject.from(dto));
            case ApprovalConst.FORM_EXPENSE -> draftMapper.updateFormExpense(FormExpense.from(dto));
            case ApprovalConst.FORM_RESIGN -> draftMapper.updateFormResign(FormResign.from(dto));
        }
    }

    private void insertFormDetail(DraftFormDto dto, String memId, int status) {
        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                validateAnnualLeave(dto, memId);
                draftMapper.insertFormAnnualLeave(FormAnnualLeave.from(dto));
            }
            case ApprovalConst.FORM_PROJECT -> draftMapper.insertFormProject(FormProject.from(dto));
            case ApprovalConst.FORM_EXPENSE -> draftMapper.insertFormExpense(FormExpense.from(dto));
            case ApprovalConst.FORM_RESIGN -> draftMapper.insertFormResign(FormResign.from(dto));
        }
    }

    private void updateApprovalDraft(DraftFormDto dto, String memId, int status) {
        draftMapper.updateApprovalDocument(dto, status, memId);
        updateFormDetail(dto, memId, status);
    }

    private void insertNewApprovalDraft(DraftFormDto dto, String memId, int status) {
        draftMapper.insertApprovalDocument(dto, status, memId);
        insertFormDetail(dto, memId, status);
    }

    private int getStatus(String action) {
        return switch (action) {
            case "temporary" -> ApprovalConst.STATUS_TEMP;
            case "save" -> ApprovalConst.STATUS_FIRST_APPROVAL_WAITING;
            default -> throw new IllegalArgumentException(
                    messageSource.getMessage("error.action.invalid", null, Locale.KOREA));
        };
    }

    private void validateAnnualLeave(DraftFormDto dto, String memId) {
        double remainAnnualLeave = getRemainAnnual(memId);

        if (remainAnnualLeave < dto.getTotalDays()) {
            throw new IllegalArgumentException(
                    messageSource.getMessage("error.annual.overflow", null, Locale.KOREA)
            );
        }
    }


    private void saveApprovalLine(DraftFormDto dto) {

        insertApprovalLine(dto.getDocId(), dto.getApprover1(), 1, ApprovalConst.REF_NO);
        insertApprovalLine(dto.getDocId(), dto.getApprover2(), 2, ApprovalConst.REF_NO);

        List<String> reffererList = dto.getReferrerList();
        if (!reffererList.isEmpty()) {
            for (String refferer : reffererList) {
                insertApprovalLine(dto.getDocId(), refferer, 0, ApprovalConst.REF_YES);
            }
        }
    }

    private void insertApprovalLine(Integer docId, String memId, int step, String refYn) {
        draftMapper.insertApprovalLine(docId, memId, step, refYn);
    }

    public DraftFormDto getDraftForm(Integer docId, String formCode) {

        DraftFormDto dto = draftMapper.getApprovalDocumentByDocId(docId);
        if (dto == null) throw new IllegalArgumentException("문서가 존재하지 않습니다.");

        switch (formCode) {
            case ApprovalConst.FORM_ANNUAL -> {
                var annual = draftMapper.getFormAnnualLeave(docId);
                if (annual != null) dto.setAnnualData(annual);
            }
            case ApprovalConst.FORM_PROJECT -> {
                var project = draftMapper.getFormProject(docId);
                if (project != null) dto.setProjectData(project);
            }
            case ApprovalConst.FORM_EXPENSE -> {
                var expense = draftMapper.getFormExpense(docId);
                if (expense != null) dto.setExpenseData(expense);
            }
            case ApprovalConst.FORM_RESIGN -> {
                var resign = draftMapper.getFormResign(docId);
                if (resign != null) dto.setresignData(resign);
            }
            default -> throw new IllegalArgumentException(
                    messageSource.getMessage("error.formtype.missing", null, Locale.KOREA));
        }

        return dto;
    }
}
