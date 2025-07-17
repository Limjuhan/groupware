package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;

@Data
//휴가신청서폼
public class FormAnnualLeave {

    private Integer docId;
    private String formCode;
    private String leaveCode;
    private LocalDate startDate;
    private LocalDate endDate;
    private Double totalDays;
    private String annualContent;
}

