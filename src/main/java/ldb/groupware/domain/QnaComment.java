package ldb.groupware.domain;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@ToString
//질문게시판 댓글
public class QnaComment {

    private Integer commentId;
    private Integer qnaId;
    private String commentText;
    private String memId;
    private String memName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String delYn;

    public String getCreatedAt() {
        return formatDate(createdAt);
    }
    public String getUpdatedAt() {
        return formatDate(updatedAt);
    }

    private String formatDate(LocalDateTime date) {
        return date != null ? date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}

