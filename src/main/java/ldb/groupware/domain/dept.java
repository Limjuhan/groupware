package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class dept {
    private String deptId;
    private String deptName;
    private String useYn;
    private String createdBy;
    private Date createdDate;
    private String updatedBy;
    private Date updatedDate;
}
