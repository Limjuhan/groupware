package ldb.groupware.domain;

import ldb.groupware.dto.draft.DraftFormDto;
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

    public static FormExpense from(DraftFormDto dto) {
        FormExpense formExpense = new FormExpense();

        formExpense.setDocId(dto.getDocId());
        formExpense.setFormCode(dto.getFormCode());
        formExpense.setUseDate(dto.getUseDate());
        formExpense.setExName(dto.getExName());
        formExpense.setExAmount(dto.getExAmount());
        formExpense.setExContent(dto.getContent());

        return formExpense;
    }
}

