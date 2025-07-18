package ldb.groupware.service.draft;

import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class DraftService {

    private final DraftMapper draftMapper;

    public DraftService(DraftMapper draftMapper) {
        this.draftMapper = draftMapper;
    }

    public List<DraftListDto> searchMyDraftList(String memId, String type, String keyword) {
        return draftMapper.getMyDraftList(memId, type, keyword);
    }

    public void getMyDraft(String docId, String writerId) {
        
    }

    public void getMyannualInfo(String docId, String writerId) {
    }
}
