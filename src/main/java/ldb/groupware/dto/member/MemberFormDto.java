package ldb.groupware.dto.member;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@Data
public class MemberFormDto {

    private String memId;
    private String memPass;

    @NotBlank(message = "이름은 필수입니다.")
    private String memName;

    @NotBlank(message = "성별을 입력하세요")
    private String memGender;

    @NotBlank(message = "전화번호는 필수입니다.")
    private String memPhone;

    @NotBlank(message = "주민번호 앞자리는 필수입니다.")
    private String juminFront;

    @NotBlank(message = "주민번호 뒷자리는 필수입니다.")
    private String juminBack;

    @NotBlank(message = "주소를 입력하세요")
    private String memAddress;

    @NotBlank(message = "재직상태는 필수입니다.")
    private String memStatus;

    @NotNull(message = "입사일은 필수입니다.")
    private LocalDate memHiredate;

    private  String memEmail;

    @NotEmpty(message = "이메일을 입력하세요")
    private String memPrivateEmail;

    @NotBlank(message = "부서를 선택해주세요.")
    private String deptId;

    @NotBlank(message = "직급을 선택해주세요.")
    private String rankId;

    private MultipartFile photo;

    private String createdBy;
}