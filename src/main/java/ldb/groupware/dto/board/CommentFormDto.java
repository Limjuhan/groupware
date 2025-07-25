package ldb.groupware.dto.board;

import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommentFormDto {
    private Integer commentId;
    private Integer qnaId;
    @Size(min = 2, max = 20)
    private String commentText;
    private String memId;
}
