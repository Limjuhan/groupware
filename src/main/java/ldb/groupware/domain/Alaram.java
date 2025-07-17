package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class Alaram {

    private int alaramId;
    private String memId;
    private String status;
    private Integer refDocId;
    private String readYn;
    private LocalDateTime createdAt;
    private int stepOrder;
}
