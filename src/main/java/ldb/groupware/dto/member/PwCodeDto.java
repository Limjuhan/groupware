package ldb.groupware.dto.member;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PwCodeDto {

    private String memId;

    private String memName;

    private String memPrivateEmail;
}
