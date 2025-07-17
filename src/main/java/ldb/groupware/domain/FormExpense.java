package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;

@Data
//지출결의서폼
public class FormExpense {

    private Integer docId;
    private String formCode;
    private LocalDate useDate;
    private String exName;
    private Integer exAmount;
    private String exContent;
}

