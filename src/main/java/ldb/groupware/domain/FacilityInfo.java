package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//공용설비 (공통)테이블
public class FacilityInfo {

    private String facId;
    private String facType;
    private String facName;
    private Integer capacity;
    private String facUid;
    private String delYn;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}

