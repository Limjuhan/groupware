package ldb.groupware.dto.facility;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
//공용설비 (공통)테이블
public class FacilityFormDto {
    private String facId;
    private String facType;
    @NotEmpty(message = "이름은 필수 입니다")
    private String facName;
    @Min(value = 1 ,message = "1 이상입력")
    @Max(value = 99,message = "99 이하 입력")
    @NotNull(message = "필수입력바랍니다")
    private Integer capacity;
    private String facUid;
}

