package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class Member {
    private String memId;
    private String deptId;
    private String rankId;
    private String memName;
    private String memGender;
    private String memEmail;
    private String memPass;
    private String memPhone;
    private String juminFront;
    private String juminBack;
    private String memAddress;
    private String memStatus;
    private LocalDate memHiredate;
    private LocalDate resignDate;
    private String createdBy;
    private LocalDateTime createdAt;
    private String updatedBy;
    private LocalDateTime updatedAt;
    private String memPrivateEmail;
}