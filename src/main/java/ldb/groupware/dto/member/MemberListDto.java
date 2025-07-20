package ldb.groupware.dto.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberListDto {
    private String memId;
    private String memName;
    private String deptName;
    private String rankName;
    private int memLevel;
}
