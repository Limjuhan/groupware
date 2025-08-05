package ldb.groupware.domain;

import ldb.groupware.dto.draft.DraftFormDto;
import lombok.Data;
import java.time.LocalDate;

@Data
//사직서 폼
public class FormResign {

    private Integer docId;
    private String formCode;
    private LocalDate resignDate;

    public static FormResign from(DraftFormDto dto) {
        FormResign formResign = new FormResign();

        formResign.setDocId(dto.getDocId());
        formResign.setFormCode(dto.getFormCode());
        formResign.setResignDate(dto.getResignDate());

        return formResign;
    }
}

