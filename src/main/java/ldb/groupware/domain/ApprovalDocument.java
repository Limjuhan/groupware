package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class ApprovalDocument {

    private Integer docId;
    private String formCode;
    private String docTitle;
    private String memId;
    private LocalDateTime createdAt;
    private String status;
    private LocalDateTime updatedAt;
    private String delYn;
    private LocalDate docEndDate;
}
