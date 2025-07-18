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
    private String deptName;
    private String rankName;
    private String juminFront;
    private String juminBack;
    private String memGender;
    private String memEmail;
    private String memPhone;
    private String memAddress;
    private String memPicture;
    private String memStatus;
    private Date memHiredate;
    private Date resignDate;
    private String birthDate;

    public void BirthDate() {
        if (this.juminFront != null && this.juminFront.length() == 6) {
            String front = this.juminFront;
            String yy = front.substring(0, 2);
            String mm = front.substring(2, 4);
            String dd = front.substring(4, 6);

            String back = this.juminBack;
            String century = "19";
            if (back != null && back.length() > 0) {
                char genderCode = back.charAt(0);
                if (genderCode == '1' || genderCode == '2') {
                    century = "19";
                } else if (genderCode == '3' || genderCode == '4') {
                    century = "20";
                }
            }
            this.birthDate = century + yy + "-" + mm + "-" + dd;
        } else {
            this.birthDate = null;
        }
    }
}