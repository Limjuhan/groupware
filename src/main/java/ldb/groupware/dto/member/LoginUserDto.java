package ldb.groupware.dto.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LoginUserDto {
    private String memId;
    private String memName;
    private String deptId;
    private String rankId;
}
