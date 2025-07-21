package ldb.groupware.dto.member;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMemberDto {
    private String memId;
    private String deptId;
    private String rankId;
}
