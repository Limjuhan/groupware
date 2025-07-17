package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//공통 타입 테이블
public class CommonType {

    private Integer commId;
    private String codeGroup;
    private String commCode;
    private String commName;
    private Integer orderNo;
    private String useYn;
    private String description;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;
}

