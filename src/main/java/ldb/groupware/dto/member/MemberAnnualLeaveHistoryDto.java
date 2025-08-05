package ldb.groupware.dto.member;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class MemberAnnualLeaveHistoryDto {
    private int hisId;
    private String memId;
    private String leaveCode;
    private LocalDate startDate;
    private LocalDate endDate;
    private double totalDays;
    private String reason;
    private String approvedBy;
    private LocalDateTime createdAt;
    private String approvedByName;
    private String leaveName;
}
