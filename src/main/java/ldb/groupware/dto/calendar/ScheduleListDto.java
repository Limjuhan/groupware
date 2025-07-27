package ldb.groupware.dto.calendar;

import lombok.Data;

import java.util.Date;

@Data
public class ScheduleListDto {
    private Long scheduleId;
    private String scheduleTitle;
    private String createdByName;
    private String scheduleContent;
    private Date startAt;
    private Date endAt;
}
