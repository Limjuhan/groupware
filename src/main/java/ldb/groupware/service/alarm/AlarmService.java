package ldb.groupware.service.alarm;

import ldb.groupware.domain.Alarm;
import ldb.groupware.dto.draft.ApprovalConst;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.mapper.mybatis.alarm.AlarmMapper;
import ldb.groupware.mapper.mybatis.draft.DraftMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

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

    public void saveAlarm(DraftFormDto dto, String memId) {
        List<Alarm> alarmList = createApprovalAlarm(dto, memId);
        int resultCnt = 0;

        for (Alarm alarm : alarmList) {
                resultCnt += alarmMapper.insertAlarm(alarm);
        }

        if (alarmList.size() != resultCnt) {
            throw new IllegalStateException("알람정보등록 실패한건 존재. docId: " + dto.getDocId());
        }
    }

    private List<Alarm> createApprovalAlarm(DraftFormDto dto, String writerId) {

        List<Alarm> alarms = new ArrayList<>();

        // 작성자 알람 (이미 읽음)
        alarms.add(new Alarm(writerId,
                ApprovalConst.STATUS_FIRST_APPROVAL_WAITING,
                dto.getDocId(),
                "Y",
                0));

        // 결재자들
        if (dto.getApprover1() != null && !dto.getApprover1().isBlank()) {
            alarms.add(new Alarm(dto.getApprover1(),
                    ApprovalConst.STATUS_FIRST_APPROVAL_WAITING,
                    dto.getDocId(),
                    "N",
                    1));
        }
        if (dto.getApprover2() != null && !dto.getApprover2().isBlank()) {
            alarms.add(new Alarm(dto.getApprover2(),
                    ApprovalConst.STATUS_FIRST_APPROVAL_WAITING,
                    dto.getDocId(),
                    "N",
                    2));
        }
        return alarms;
    }
}
