package ldb.groupware.dto.admin;

import lombok.Data;

@Data
public class MenuDto {
    private String menuCode;
    private String menuName;
    private String description;
    private String useYn;
}
