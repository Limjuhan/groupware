package ldb.groupware.dto.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class LoginUserDto {
    private String memId;
    private String memName;
    private String deptId;
    private String rankId;

    private String memGender;
    private String memEmail;
    private String memPhone;
    private String memAddress;
    private String memPicture;
    private String memStatus;

    private Date memHiredate;
    private Date resignDate;

    private String birthDate;
}
