package ldb.groupware.dto.member;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMemberDto {
    private String memId;
    private String deptId;
    private String rankId;
    private String updatedBy;
    private LocalDateTime updatedAt;
}
