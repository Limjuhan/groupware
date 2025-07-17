package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class CompanySchedule {

    private int scheduleId;
    private String scheduleTitle;
    private String scheduleContent;
    private Date startAt;
    private Date endAt;
    private String createdBy;
    private Date createdAt;
    private Date updatedAt;
    private String updatedBy;
}
