package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PasswordChangeDto {

    @NotBlank(message = "현재 비밀번호를 입력하세요.")
    private String curPw;

    @NotBlank(message = "새 비밀번호를 입력하세요.")
    private String newPw;

    @NotBlank(message = "새 비밀번호 확인을 입력하세요.")
    private String chkPw;
}
