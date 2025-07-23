package ldb.groupware.dto.member;

import lombok.Data;

@Data
public class MemberAnnualLeaveDto {
    private int anId;
    private String memId;
    private int year;
    private double totalDays;
    private double useDays;
    private double remainDays;
}
