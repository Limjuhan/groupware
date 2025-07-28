package ldb.groupware.dto.calendar;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class ScheduleListDto {
    private Integer scheduleId;
    private String scheduleTitle;
    private String scheduleContent;
    private LocalDateTime startAt;
    private LocalDateTime endAt;

    public String getStartAtStr() {
        return formatDateTime(startAt);
    }

    public String getEndAtStr() {
        return formatDateTime(endAt);
    }

    private String formatDateTime(LocalDateTime dateTime) {
        return dateTime != null ? dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
    }
}
