package ldb.groupware.domain;
import lombok.Data;
import java.time.LocalDate;

@Data
//프로젝트제안서 폼
public class FormProject {

    private Integer docId;
    private String formCode;
    private String projectName;
    private String proContent;
    private LocalDate startDate;
    private LocalDate endDate;
}

