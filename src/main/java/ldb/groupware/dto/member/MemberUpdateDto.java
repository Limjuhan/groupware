package ldb.groupware.dto.member;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberUpdateDto {

    private String memId;
    @NotBlank(message = "전화번호를 입력하세요")
    private String phone;
    @NotBlank(message = "이메일을 입력하세요")
    @Email(message = "올바른 이메일 형식이어야 합니다")
    private String privateEmail;
    @NotBlank(message = "주소를 입력하세요")
    private String address;
}
