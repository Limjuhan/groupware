package ldb.groupware.dto.member;

import lombok.Data;

import java.time.LocalDate;

@Data
public class MemberAnnualLeaveHistoryDto {
    private LocalDate startDate;
    private LocalDate endDate;
    private String leaveCode;
    private String leaveName;
    private String approvedBy;
    private String approvedByName;
}
