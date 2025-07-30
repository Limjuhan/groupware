package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftUpdateDto {
    private Integer docId;
    private Integer status;
    private String action;
    private String comment;
    private String formCode;
}
