package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ResetPwDto {
    @NotBlank(message = "사원번호를 입력하세요.")
    private String memId;

    @NotBlank(message = "새 비밀번호를 입력하세요.")
    private String newPw;

    @NotBlank(message = "비밀번호 확인을 입력하세요.")
    private String confirmPw;
}
