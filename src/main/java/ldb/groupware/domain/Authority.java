package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class Authority {
    private String authCode;
    private String authName;
    private String description;
    private String useYn;
    private String createdBy;
    private Date createdDate;
    private String updatedBy;
    private Date updatedDate;
}
