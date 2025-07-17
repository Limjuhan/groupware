package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Qna {

    private Integer qnaId;
    private String qnaTitle;
    private String qnaContent;
    private String memId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String delYn;
    private Integer viewCount;
}

