package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftUpdateDto {
    private String docId;
    private Integer status;
    private String action;
    private String comment;
}
