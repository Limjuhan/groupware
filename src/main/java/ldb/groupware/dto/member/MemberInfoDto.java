package ldb.groupware.dto.member;

import lombok.Data;

import java.time.LocalDate;

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
    private LocalDate memHiredate;
    private String memGender;
    private LocalDate birthDate;
    private String memAddress;
    private String memPicture;
}