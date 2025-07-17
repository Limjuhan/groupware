package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//질문게시판 댓글
public class QnaComment {

    private Integer commentId;
    private Integer qnaId;
    private String commentText;
    private String memId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String delYn;
}

