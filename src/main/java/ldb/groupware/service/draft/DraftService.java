package ldb.groupware.service.draft;

import io.micrometer.common.util.StringUtils;
import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.mapper.mapstruct.ConvertDtoMapper;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import ldb.groupware.service.attachment.AttachmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Service
public class DraftService {

    private final DraftMapper draftMapper;
    private final AttachmentService attachmentService;
    private final ConvertDtoMapper convertDtoMapper;

    public DraftService(DraftMapper draftMapper, AttachmentService attachmentService, ConvertDtoMapper convertDtoMapper) {
        this.draftMapper = draftMapper;
        this.attachmentService = attachmentService;
        this.convertDtoMapper = convertDtoMapper;
    }

    public List<DraftListDto> searchMyDraftList(String memId, String type, String keyword) {
        return draftMapper.getMyDraftList(memId, type, keyword);
    }

    public void getMyDraft(String docId, String writerId) {
        
    }

    public void getMyannualInfo(String docId, String writerId) {
    }

    public List<DraftForMemberDto> getMemberList() {
        return draftMapper.getMemberList();
    }

    public Integer getReaminAnnual(String memId) {
        return draftMapper.getReaminAnnual(memId);
    }

    /**
     *
     * @param dto
     * @param attachments
     * @param action
     * @param memId
     *  상신시 저장DB
     *  연차 사용시 해당 사용자의 총연차를 구해서 사용가능한지 검증도 해야함
     *  attachment
     *  approval_document
     *  approval_line
     *  form_annual_leave
     *  form_expense
     *  form_resign
     *
     * TODO: approval_document,form_annual_leave 진행함. 해당프로세스에 남은잔여연차량검증 없음 생성해야함.
     * TODO: _line테이블 진행 및 연차생성관련 배치프로세스 정리하기
     */
    @Transactional
    public void saveDraft(DraftFormDto dto, List<MultipartFile> attachments, String action, String memId) {


        if (action.equals("save")) {
            insertDraft(dto, memId);


            attachmentService.saveAttachments("21", "D", attachments);
        }
    }

    private void insertDraft(DraftFormDto dto, String memId) {
        // approval_document 삽입
        draftMapper.insertApprovalDocument(dto, memId);

        if (!StringUtils.isBlank(dto.getFormType())) {
            switch (dto.getFormType()) {
                case "app_01": // 연차
                    FormAnnualLeave formAnnualLeave = dto.createFormAnnualLeave();
                    draftMapper.insertFormAnnualLeave(formAnnualLeave);
                    break;
//                case "app_02": // 프로젝트
//                    draftMapper.insertProject();
//                    break;
//                case "app_03": // 지출결의서
//                    draftMapper.insertExpense();
//                    break;
//                case "app_04": // 사직서
//                    draftMapper.insertResign();
//                    break;

                default: throw new IllegalArgumentException("잘못된 결재양식 입니다.");
            }
        } else {
            throw new IllegalArgumentException("선택된 결재양식이 존재하지 않습니다.");
        }


    }
}
