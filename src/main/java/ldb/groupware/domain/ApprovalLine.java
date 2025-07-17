package ldb.groupware.domain;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ApprovalLine {

    private Integer lineId;
    private Integer docId;
    private String memId;
    private Integer stepOrder;
    private String status;
    private LocalDateTime approvedAt;
    private String approvedComment;
    private String refYn;
}

