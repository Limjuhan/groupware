package ldb.groupware.service.alarm;

import ldb.groupware.dto.draft.ApprovalConst;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.mapper.mybatis.alarm.AlarmMapper;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AlarmService {
    private final AlarmMapper alarmMapper;
    private final DraftMapper draftMapper;

    public AlarmService(AlarmMapper alarmMapper, DraftMapper draftMapper) {
        this.alarmMapper = alarmMapper;
        this.draftMapper = draftMapper;
    }

    public void updateAlarm(Integer docId, Integer status, int chgStatus) {
        DraftFormDto draftFormDto = draftMapper.getApprovalDocumentByDocId(docId);
        int isDel = 0;

        try {
            if (status == ApprovalConst.STATUS_FIRST_APPROVAL_WAITING) {
                isDel = alarmMapper.updateAlarmByDocId(docId, draftFormDto.getApprover2(), chgStatus);
            } else if (status == ApprovalConst.STATUS_SECOND_APPROVAL_WAITING) {
                isDel = alarmMapper.updateAlarmByDocId(docId, draftFormDto.getMemId(), chgStatus);
            }
            if (isDel < 1) {
                throw new IllegalStateException("알람 업데이트 작업 실패");
            }
        } catch (Exception e) {
            log.error("[받은전자결내역 프로세스]알람등록 실패. docId: {}", docId);
            throw new RuntimeException("알람업데이트 작업 실패");
        }
    }



}
