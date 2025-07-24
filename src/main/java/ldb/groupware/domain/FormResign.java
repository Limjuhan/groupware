package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;

@Data
//사직서 폼
public class FormResign {

    private Integer docId;
    private String formCode;
    private LocalDate resignDate;
}

