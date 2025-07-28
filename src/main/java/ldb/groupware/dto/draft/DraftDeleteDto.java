package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftDeleteDto {
    private Integer docId;
    private String formCode;
    private String status;
}
