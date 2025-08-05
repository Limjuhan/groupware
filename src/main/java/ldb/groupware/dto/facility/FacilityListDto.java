package ldb.groupware.dto.facility;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

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

