package ldb.groupware.dto.admin;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DashboardInfoDto {
    private String memId;
    private String deptId;
    private String deptName;
    private String memName;
    private String rankName; // 직급
    private Integer totalDays;
    private Integer useDays;
    private Integer remainDays;
    private String annualPercent;
    private Integer realYear;

    public String getAnnualPercent() {
        return calcAnnualPercent();
    }

    private String calcAnnualPercent() {
        if (totalDays == null || totalDays == 0 || useDays == null) {
            return "0%";
        }
        // 소수점 버림 → 정수 % 값
        int percent = (int) Math.round((useDays.doubleValue() / totalDays.doubleValue()) * 100);
        return percent + "%";
    }

}
