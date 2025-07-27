package ldb.groupware.dto.facility;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Setter
@ToString
//공용설비 (공통)테이블
public class FacilityListDto {

    private String facId;
    private String facType;
    private String facName;
    private Integer capacity;
    private String facUid;
    private String rentYn;
}

