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
     * 임시저장한글 불러와서 또 임시저장하는 경우도 생각해야함
     *
     * @param dto
     * @param attachments
     * @param action
     * @param memId
     *
     */
    @Transactional
    public void saveDraft(DraftFormDto dto, List<MultipartFile> attachments, String action, String memId) throws IllegalArgumentException {

        int status = action.equals("temporary") ? ApprovalConst.STATUS_TEMP : ApprovalConst.STATUS_FIRST_APPROVAL_WAITING;

        draftMapper.insertApprovalDocument(dto, status, memId);
        saveDraftForm(dto);

        if (action.equals("save")) {
            validateAnnualLeave(dto, memId); // 연차 검증
            saveApprovalLine(dto); // 결재선 insert
        }

        // 첨부파일 저장
        attachmentService.saveAttachments(dto.getDocId().toString(), dto.getAttachType(), attachments);
    }

    private void saveDraftForm(DraftFormDto dto) {

        if (dto.getFormCode().equals(ApprovalConst.FORM_ANNUAL)) {
            draftMapper.insertFormAnnualLeave(FormAnnualLeave.from(dto));
        } else if (dto.getFormCode().equals(ApprovalConst.FORM_PROJECT)) {

        } else if (dto.getFormCode().equals(ApprovalConst.FORM_EXPENSE)) {

        } else if (dto.getFormCode().equals(ApprovalConst.FORM_RESIGN)) {

        }

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

        DraftFormDto draftFormDto = draftMapper.getApprovalDocumentByDocId(docId);

        if (formCode.equals(ApprovalConst.FORM_ANNUAL)) {
            draftFormDto.setAnnualData(draftMapper.getFormAnnualLeave(docId));
        } else if (formCode.equals(ApprovalConst.FORM_PROJECT)) {
            draftFormDto.setProjectData(draftMapper.getFormProject(docId));
        } else if (formCode.equals(ApprovalConst.FORM_EXPENSE)) {
            draftFormDto.setExpenseData(draftMapper.getFormExpense(docId));
        } else if (formCode.equals(ApprovalConst.FORM_RESIGN)) {
            draftFormDto.setresignData(draftMapper.getFormResign(docId));
        } else {
            throw new IllegalArgumentException(
                    messageSource.getMessage("error.formtype.missing", null, Locale.KOREA)
            );
        }

        return draftFormDto;
    }
}
