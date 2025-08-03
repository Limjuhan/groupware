package ldb.groupware.dto.admin;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class UpdateAnnualDto {

    private String memId;
    private double totalDays;
    private double useDays;
    private double remainDays;
    private int year;

}
