package ldb.groupware.dto.member;

import lombok.Data;

import java.util.Date;

@Data
public class MemberInfoDto {
    private String memId;
    private String memName;
    private String memEmail;
    private String memPrivateEmail;
    private String memPhone;
    private String deptName;
    private String rankName;
    private String memStatus;
    private Date memHiredate;
    private String memGender;
    private String birthDate;
    private String memAddress;
    private String memPicture;
}