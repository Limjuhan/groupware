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
    private Double requestDays;
    private String annualContent;

    public static FormAnnualLeave from(DraftFormDto dto) {

        FormAnnualLeave formAnnualLeave = new FormAnnualLeave();
        formAnnualLeave.setDocId(dto.getDocId());
        formAnnualLeave.setFormCode(dto.getFormCode());
        formAnnualLeave.setLeaveCode(dto.getLeaveCode());
        formAnnualLeave.setStartDate(dto.getLeaveStart());
        formAnnualLeave.setEndDate(dto.getLeaveEnd());
        if (dto.getLeaveStart() != null && dto.getLeaveEnd() != null) {
            long days = ChronoUnit.DAYS.between(dto.getLeaveStart(), dto.getLeaveEnd()) + 1;
            formAnnualLeave.setRequestDays((double) days);
        } else {
            formAnnualLeave.setRequestDays(0.0);
        }
        formAnnualLeave.setAnnualContent(dto.getContent());

        return formAnnualLeave;
    }
}

