package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CodeDto {
    @NotBlank(message = "사원번호를 입력하세요.")
    private String memId;

    @NotBlank(message = "인증번호를 입력하세요.")
    private String inputCode;
}
