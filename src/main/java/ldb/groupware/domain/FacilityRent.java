package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//공용설비 예약내역
public class FacilityRent {

    private Integer rentalNo;
    private String facId;
    private String facType;
    private String renterId;
    private String rentalPurpose;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private String rentYn; //반납여부
    private LocalDateTime createdAt;
    private String createdBy;
}
