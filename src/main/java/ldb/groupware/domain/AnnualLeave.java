package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class AnnualLeave {
    private Integer anId;
    private String memId;// 사원ID
    private Integer year;// 년도
    private Double totalDays;// 해당년도 총지급연차일수
    private Double useDays;// 사용연차일수
    private Double remainDays;// 남은 연차일수
    private LocalDateTime createdAt;// 생성일시
    private String createdBy;// 생성자(배치통해 입력할예정이기때문에 관리자ID가 될예정)
    private LocalDateTime updatedAt;// 연차소진or취소에 따른 수정일시
    private String updatedBy;// 2차결재자ID로 올라갈예정

    public AnnualLeave() {
    }

    public AnnualLeave(String memId,
                       int hireYear,
                       double totalDays,
                       double useDays,
                       double remainDays) {
        this.memId = memId;
        this.year = hireYear;
        this.totalDays = totalDays;
        this.useDays = useDays;
        this.remainDays = remainDays;
        this.createdAt = LocalDateTime.now();
        this.createdBy = "AnnualBatch";
    }

    public void updateMonthAnnualByBatch(Double totalDays, Double remainDays) {
        this.totalDays = totalDays + 1;
        this.remainDays = remainDays + 1;
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = "AnnualBatch";
    }

    public void updateRegularAnnualByBatch(Double totalDays, Double remainDays) {
        this.totalDays = totalDays;
        this.remainDays = remainDays;
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = "AnnualBatch";
    }
}
