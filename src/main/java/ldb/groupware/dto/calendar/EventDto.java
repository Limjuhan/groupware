package ldb.groupware.dto.calendar;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class EventDto {
    private Integer id;
    private String title;
    private String content;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime start;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime end;

    public boolean isEndAfterStart() {
        if (start == null || end == null) return true;
        return !end.isBefore(start);
    }
}


