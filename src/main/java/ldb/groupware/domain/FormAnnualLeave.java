package ldb.groupware.domain;

import ldb.groupware.dto.draft.DraftFormDto;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Getter
@Setter
@ToString
public class FormAnnualLeave {

    private Integer docId;
    private String formCode;
    private String leaveCode;
    private LocalDate startDate;
    private LocalDate endDate;
    private Double totalDays;
    private String annualContent;

    public static FormAnnualLeave from(DraftFormDto dto) {
        if (dto.getLeaveStart() == null || dto.getLeaveEnd() == null) {
            throw new IllegalArgumentException("휴가 시작일과 종료일은 필수입니다.");
        }

        FormAnnualLeave formAnnualLeave = new FormAnnualLeave();
        formAnnualLeave.setDocId(dto.getDocId());
        formAnnualLeave.setFormCode(dto.getFormCode());
        formAnnualLeave.setLeaveCode(dto.getLeaveCode());
        formAnnualLeave.setStartDate(dto.getLeaveStart());
        formAnnualLeave.setEndDate(dto.getLeaveEnd());
        formAnnualLeave.setTotalDays((double) (ChronoUnit.DAYS.between(dto.getLeaveStart(), dto.getLeaveEnd()) + 1));
        formAnnualLeave.setAnnualContent(dto.getContent());

        return formAnnualLeave;
    }
}

