package ldb.groupware.dto.member;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class MemberFormDto {

    @NotBlank(message = "이름은 필수입니다.")
    private String memName;

    private String memGender;

    @NotBlank(message = "전화번호는 필수입니다.")
    private String memPhone;

    @NotBlank(message = "주민번호 앞자리는 필수입니다.")
    @Pattern(regexp = "\\d{6}", message = "앞자리는 6자리 숫자여야 합니다.")
    private String juminFront;

    @NotBlank(message = "주민번호 뒷자리는 필수입니다.")
    @Pattern(regexp = "\\d{7}", message = "뒷자리는 7자리 숫자여야 합니다.")
    private String juminBack;

    private String memAddress;

    @NotBlank(message = "재직상태는 필수입니다.")
    private String memStatus;

    @NotNull(message = "입사일은 필수입니다.")
    private LocalDate memHiredate;
}
