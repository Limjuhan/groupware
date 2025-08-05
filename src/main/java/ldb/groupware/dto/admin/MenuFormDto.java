package ldb.groupware.dto.admin;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class MenuFormDto {
    private String menuCode;
    @NotBlank(message = "메뉴 이름은 필수입니다.")
    private String menuName;
    private String description;
    @NotBlank(message = "사용여부는 필수입니다.")
    private String useYn;
}
