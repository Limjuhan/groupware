package ldb.groupware.dto.member;

import lombok.Data;

@Data
public class MemberListDto {
    private String memId;
    private String memName;
    private String deptId;
    private String deptName;
    private String rankId;
    private String rankName;
    private int memLevel;
}
