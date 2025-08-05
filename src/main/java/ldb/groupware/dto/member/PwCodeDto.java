package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PwCodeDto {
    @NotNull
    private String memId;
    @NotNull
    private String memName;
    @NotNull
    private String memPrivateEmail;
}
