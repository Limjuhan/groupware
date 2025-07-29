package ldb.groupware.dto.facility;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Data
//공용설비 예약내역
public class MyFacilityReserveDto {

    private String facId;
    private String facType;
    private String facName;
    private String facUid;
    private String commName;
    private String renterId;
    private String rentYn;
    private String cancelStatus;

    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private LocalDateTime createdAt;

    public String getStartAt(){
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return dtf.format(startAt);
    }

    public String getEndAt(){
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return dtf.format(endAt);
    }
    public String getCreatedAt(){
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd ");
        return dtf.format(createdAt);
    }



}
