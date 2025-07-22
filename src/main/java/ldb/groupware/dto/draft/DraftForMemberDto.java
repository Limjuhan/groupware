package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftForMemberDto {
    private String memId;
    private String memName;
    private String deptName;
    private String rankName;
    private String memEmail;
}
