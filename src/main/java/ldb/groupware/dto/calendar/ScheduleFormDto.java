package ldb.groupware.dto.calendar;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class ScheduleFormDto {
    private Integer scheduleId;
    @NotBlank(message = "제목은 필수 입력입니다")
    private String scheduleTitle;
    @NotBlank(message = "내용 입력은 필수입니다.")
    private String scheduleContent;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    @NotNull(message = "시작일 입력은 필수입니다.")
    private LocalDateTime startAt;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    @NotNull(message = "종료일 입력은 필수입니다.")
    private LocalDateTime endAt;

    public boolean isEndAfterStart() {
        if (startAt == null || endAt == null) return true;
        return !endAt.isBefore(startAt);
    }

}
