package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class Alarm {

    private int alaramId;
    private String memId;
    private int stepOrder;
    private Integer status;
    private Integer refDocId;
    private String readYn;
    private LocalDateTime createdAt;

    public Alarm() {
    }

    public Alarm(String memId, Integer status, Integer refDocId, String readYn, int stepOrder) {
        this.memId = memId;
        this.status = status;
        this.refDocId = refDocId;
        this.readYn = readYn;
        this.stepOrder = stepOrder;
    }

}
