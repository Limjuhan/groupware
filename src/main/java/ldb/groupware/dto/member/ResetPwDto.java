package ldb.groupware.dto.member;

import lombok.Data;

@Data
public class ResetPwDto {

    private String memId;

    private String newPw;

    private String confirmPw;
}
