package ldb.groupware.dto.board;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
public class QnaUpdateDto {
    private Integer qnaId;
    @NotEmpty(message = "제목은 입력해야죠")
    private String qnaTitle;

    private String qnaContent;
    private String memId;
    private String memName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<String> existingFiles;

}
