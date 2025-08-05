package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ResetPwDto {
    @NotNull
    private String memId;
    @NotNull
    private String newPw;
    @NotNull
    private String confirmPw;
}
