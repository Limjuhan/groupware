package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CodeDto {
    @NotNull
    private String memId;
    @NotNull
    private String inputCode;
}
