package ldb.groupware.dto.member;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@Getter
@Setter
public class MemberUpdateDto {
    private String memId;
    private String memName;
    private String memEmail;
    private String deptName;
    private String rankName;
    private String memStatus;
    private LocalDate memHiredate;
    private String memGender;
    private String juminBack;
    private String memPicture;
    private String juminFront;
    private LocalDate birthDate;

    @NotBlank(message = "전화번호를 입력하세요")
    private String memPhone;

    @NotBlank(message = "이메일을 입력하세요")
    @Email(message = "올바른 이메일 형식이어야 합니다")
    private String privateEmail;

    @NotBlank(message = "주소를 입력하세요")
    private String address;

    private MultipartFile photo;
    private String deletePhoto;


    public void setJuminFront(String juminFront) {
        this.juminFront = juminFront;

        if (juminFront != null && juminFront.length() == 6) {
            try {
                int year = Integer.parseInt(juminFront.substring(0, 2));
                int month = Integer.parseInt(juminFront.substring(2, 4));
                int day = Integer.parseInt(juminFront.substring(4, 6));
                int currentYear = LocalDate.now().getYear() % 100;
                int fullYear = (year <= currentYear) ? 2000 + year : 1900 + year;
                this.birthDate = LocalDate.of(fullYear, month, day);
            } catch (Exception e) {
                this.birthDate = null;
            }
        } else {
            this.birthDate = null;
        }
    }
}