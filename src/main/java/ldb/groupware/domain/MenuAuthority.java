package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;

@Data
public class MenuAuthority {

    private String deptId;
    //A_001 ~ A_006 컬럼은 Java에서는 a001 ~ a006 형태로 자동 변환됨
    private String a001;
    private String a002;
    private String a003;
    private String a004;
    private String a005;
    private String a006;
    private LocalDate createdDate;
    private String createdBy;
    private String updatedBy;
    private LocalDate updatedDate;
}
