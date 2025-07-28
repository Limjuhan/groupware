package ldb.groupware.dto.facility;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Data
//공용설비 예약내역
public class FacilityRentDto {

    private String facId;
    private String facType;
    private String facName;
    private String renterId;
    private String rentalPurpose;

    private Date startAt;
    private Date endAt;
    private LocalDateTime startLocalDateTime;
    private LocalDateTime endLocalDateTime;
    private LocalDateTime createdAt;
    private String createdBy;


    //Date --> LocalDateTime
    public LocalDateTime getStartLocalDateTime() {
        if (startAt == null) return null;
        return startAt.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();
    }
    public LocalDateTime getEndLocalDateTime() {
        if (endAt == null) return null;
        return endAt.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();
    }


}
