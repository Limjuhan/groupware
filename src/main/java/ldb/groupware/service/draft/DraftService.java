package ldb.groupware.service.draft;

import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import ldb.groupware.service.attachment.AttachmentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Service
public class DraftService {

    private final DraftMapper draftMapper;
    private final AttachmentService attachmentService;

    public DraftService(DraftMapper draftMapper, AttachmentService attachmentService) {
        this.draftMapper = draftMapper;
        this.attachmentService = attachmentService;
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

    public void saveDraft(DraftFormDto dto, List<MultipartFile> attachments, String action, String memId) {

        if (action.equals("save")) {
            attachmentService.saveAttachments(21, "D", attachments);
        }
    }
}
