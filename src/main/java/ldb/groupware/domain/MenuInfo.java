package ldb.groupware.domain;

import lombok.Data;

import java.time.LocalDate;

@Data
public class MenuInfo {
    private String menuCode;
    private String menuName;
    private String description;
    private String useYn;
    private LocalDate createdDate;
    private String createdBy;
    private String updatedBy;
    private LocalDate updatedDate;
}
