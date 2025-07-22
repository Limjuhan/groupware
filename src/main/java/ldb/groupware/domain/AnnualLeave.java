package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class AnnualLeave {
    private Integer anId;
    private String memId;
    private Integer year;
    private Double totalDays;
    private Double useDays;
    private Double remainDays;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}
