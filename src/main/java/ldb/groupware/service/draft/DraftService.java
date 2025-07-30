package ldb.groupware.service.draft;

import ldb.groupware.domain.*;
import ldb.groupware.dto.common.CommonConst;
import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.draft.*;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mapstruct.ConvertDtoMapper;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.service.common.CommonService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class DraftService {

    private final DraftMapper draftMapper;
    private final AttachmentService attachmentService;
    private final MessageSource messageSource;
    private final CommonService commonService;

    public DraftService(DraftMapper draftMapper, AttachmentService attachmentService, MessageSource messageSource, CommonService commonService) {
        this.draftMapper = draftMapper;
        this.attachmentService = attachmentService;
        this.messageSource = messageSource;
        this.commonService = commonService;
    }

    public Map<String, Object> searchMyDraftList(String memId, MyDraftSearchDto dto, int page) {

        Map<String, Object> countParam = new HashMap<>();
        countParam.put("memId", memId);
        countParam.put("keyword", dto.getKeyword());
        countParam.put("searchType", dto.getSearchType());
        countParam.put("searchStatus", dto.getSearchStatus());

        int totalRows = draftMapper.getMyDraftCount(countParam);

        dto.setPageData(page,totalRows);
        dto.calculatePagination();

        List<DraftListDto> list = draftMapper.getMyDraftList(dto, memId);

        Map<String, Object> result = new HashMap<>();
        result.put("data", list);
        result.put("page", dto);

        return result;
    }

    public List<DraftForMemberDto> getMemberList() {
        return draftMapper.getMemberList();
    }

    public Integer getRemainAnnual(String memId) {
        Integer remainAnnual = draftMapper.getRemainAnnual(memId);
        if (remainAnnual == null) {
            remainAnnual = 0;
        }
        return remainAnnual;
    }

    /**
     * 최초 상신시 : attachment, approval_document, approval_line
     * form_annual_leave, form_expense, form_resign, annual_leave_history
     *
     * @param dto
     * @param attachments
     * @param action
     * @param memId
     */
    @Transactional
    public void saveDraft(DraftFormDto dto,
                          List<MultipartFile> attachments,
                          String action,
                          String memId,
                          String savedFormCode) throws IllegalArgumentException {

        //글등록방식(임시저장or제출) 확인
        int saveType = getStatus(action);

        if (dto.getStatus() != null && dto.getStatus() == ApprovalConst.STATUS_TEMP) { // 임시저장 -> 임시저장 or 제출
            if (savedFormCode != null && !dto.getFormCode().equals(savedFormCode)) {
                throw new IllegalArgumentException("임시저장된문서 제출(or임시저장)시 같은양식만 가능합니다.");
            }
            updateApprovalDraft(dto, memId, saveType);
        } else { // 새글작성->임시저장 or 제출
            insertNewApprovalDraft(dto, memId, saveType);
        }

        if (action.equals("save")) {// 새글작성 -> 제출
            saveApprovalLine(dto); // 결재선 저장
        }

        attachmentService.saveAttachments(dto.getDocId().toString(), dto.getAttachType(), attachments);
    }

    private void updateFormDetail(DraftFormDto dto, String memId, int saveType) {
        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                // 임시저장은 유효성검사 x
                if (saveType != ApprovalConst.STATUS_TEMP) {
                    validateAnnualLeave(dto, memId);
                }
                draftMapper.updateFormAnnualLeave(FormAnnualLeave.from(dto));
            }
            case ApprovalConst.FORM_PROJECT -> draftMapper.updateFormProject(FormProject.from(dto));
            case ApprovalConst.FORM_EXPENSE -> draftMapper.updateFormExpense(FormExpense.from(dto));
            case ApprovalConst.FORM_RESIGN -> draftMapper.updateFormResign(FormResign.from(dto));
        }
    }

    private void insertFormDetail(DraftFormDto dto, String memId, int saveType) {
        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                // 임시저장은 유효성검사 x
                if (saveType != ApprovalConst.STATUS_TEMP) {
                    validateAnnualLeave(dto, memId);
                }
                draftMapper.insertFormAnnualLeave(FormAnnualLeave.from(dto));
            }
            case ApprovalConst.FORM_PROJECT -> draftMapper.insertFormProject(FormProject.from(dto));
            case ApprovalConst.FORM_EXPENSE -> draftMapper.insertFormExpense(FormExpense.from(dto));
            case ApprovalConst.FORM_RESIGN -> draftMapper.insertFormResign(FormResign.from(dto));
        }
    }

    private void updateApprovalDraft(DraftFormDto dto, String memId, int saveType) {
        draftMapper.updateApprovalDocument(dto, saveType, memId);
        updateFormDetail(dto, memId, saveType);
    }

    private void insertNewApprovalDraft(DraftFormDto dto, String memId, int saveType) {
        draftMapper.insertApprovalDocument(dto, saveType, memId);
        insertFormDetail(dto, memId, saveType);
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

    public DraftFormDto getDraftForm(DraftFormDto dto) {

        if (dto.getDocId() == null) {
            throw new IllegalArgumentException("문서가 존재하지 않습니다.");
        }

        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                var annual = draftMapper.getFormAnnualLeave(dto.getDocId());
                if (annual != null) dto.setAnnualData(annual);
            }
            case ApprovalConst.FORM_PROJECT -> {
                var project = draftMapper.getFormProject(dto.getDocId());
                if (project != null) dto.setProjectData(project);
            }
            case ApprovalConst.FORM_EXPENSE -> {
                var expense = draftMapper.getFormExpense(dto.getDocId());
                if (expense != null) dto.setExpenseData(expense);
            }
            case ApprovalConst.FORM_RESIGN -> {
                var resign = draftMapper.getFormResign(dto.getDocId());
                if (resign != null) dto.setresignData(resign);
            }
            default -> throw new IllegalArgumentException(
                    messageSource.getMessage("error.formtype.missing", null, Locale.KOREA));
        }

        return dto;
    }

    public DraftFormDto getMyDraftDetail(DraftFormDto dto) {
        dto = draftMapper.getMyDraftDetail(dto.getDocId());
        getDraftForm(dto);

        return dto;
    }

    @Transactional
    public void deleteMyDraft(DraftDeleteDto dto) {

        if (draftMapper.deleteApprovalDocument(dto) == 0 || deleteDraftForm(dto) == 0) {
            log.warn("기안문서 삭제 실패 - 존재하지 않거나 이미 삭제됨: {}", dto.getDocId());
            throw new IllegalStateException("삭제할 문서가 없거나 실패했습니다.");
        }

        // 첨부파일 삭제
        Optional<List<Attachment>> attachList = attachmentService.getAttachments(dto.getDocId().toString(), dto.getAttachType());

        attachList.ifPresent(attachs -> {
            List<String> attachSavedNames = attachs.stream()
                    .map(Attachment::getSavedName)
                    .collect(Collectors.toList());
            System.out.println("삭제시 첨부파일내역확인: " + attachSavedNames.toString());

            attachmentService.deleteAttachment(attachSavedNames, dto.getAttachType());
        });

    }


    private int deleteDraftForm(DraftDeleteDto dto) {
        int result = 0;
        switch (dto.getFormCode()) {
            case ApprovalConst.FORM_ANNUAL -> {
                result = draftMapper.deleteFormAnnualLeave(dto.getDocId());
            }
            case ApprovalConst.FORM_PROJECT -> {
                result = draftMapper.deleteFormProject(dto.getDocId());
            }
            case ApprovalConst.FORM_EXPENSE -> {
                result = draftMapper.deleteFormExpense(dto.getDocId());
            }
            case ApprovalConst.FORM_RESIGN -> {
                result = draftMapper.deleteFormResign(dto.getDocId());
            }
            default -> throw new IllegalArgumentException(
                    messageSource.getMessage("error.formtype.missing", null, Locale.KOREA));
        }
        return result;
    }

    public Map<String, Object> searchReceivedDraftList(String memId, MyDraftSearchDto dto, int page) {

        int totalRows = draftMapper.getReceivedDraftCount(dto, memId);

        dto.setPageData(page,totalRows);
        dto.calculatePagination();

        List<DraftListDto> draftList = draftMapper.getReceivedDraftList(dto, memId);

        Map<String, Object> result = new HashMap<>();
        result.put("page", dto);
        result.put("data", draftList);

        return result;
    }

    //TODO: 마지막 작업구간. 7/30 오후 6시
    public void approveDraft(DraftUpdateDto dto, String memId) {
        
    }

    public void rejectDraft(DraftUpdateDto dto, String memId) {
    }
}
