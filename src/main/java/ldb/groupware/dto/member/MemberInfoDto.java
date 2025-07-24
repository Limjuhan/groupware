package ldb.groupware.dto.member;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class MemberInfoDto {
    private String memId;
    private String memName;
    private String memEmail;
    private String deptName;
    private String rankName;
    private String memStatus;
    private LocalDate memHiredate;
    private String memGender;
    private String juminFront;
    private String juminBack;
    private String memAddress;
    private LocalDate birthDate;
    private String memPhone;
    private String privateEmail;

    private String memPicture;
    private String memPictureSavedName;

    private Integer anId;
    private Integer year;
    private Double totalDays;
    private Double useDays;
    private Double remainDays;

    private List<MemberAnnualLeaveHistoryDto> annualHistoryList;

    public void setJuminFront(String juminFront) {
        this.juminFront = juminFront;
        if (juminFront != null && juminFront.length() == 6) {
            try {
                int year = Integer.parseInt(juminFront.substring(0, 2));
                int month = Integer.parseInt(juminFront.substring(2, 4));
                int day = Integer.parseInt(juminFront.substring(4, 6));
                int currentYear = LocalDate.now().getYear() % 100;
                int fullYear = (year <= currentYear) ? 2000 + year : 1900 + year;
                this.birthDate = LocalDate.of(fullYear, month, day);
            } catch (Exception e) {
                this.birthDate = null;
            }
        }
    }
}
