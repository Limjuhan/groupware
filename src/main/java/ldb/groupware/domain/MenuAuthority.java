package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;

@Data
public class MenuAuthority {

    private String deptId;
    private String menuCode;
    private LocalDate createdDate;
    private String createdBy;
    private String updatedBy;
    private LocalDate updatedDate;
}
