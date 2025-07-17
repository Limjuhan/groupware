package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//자주묻는질문
public class Faq {

    private Integer faqId;
    private String deptId;
    private String faqTitle;
    private String faqContent;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

