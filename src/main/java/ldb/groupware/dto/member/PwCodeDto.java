package ldb.groupware.dto.member;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PwCodeDto {

    @NotBlank(message = "사원번호를 입력하세요.")
    private String memId;

    @NotBlank(message = "이름을 입력하세요.")
    private String memName;

    @NotBlank(message = "이메일을 입력하세요.")
    @Email(message = "이메일 형식이 아닙니다.")
    private String memPrivateEmail;
}
