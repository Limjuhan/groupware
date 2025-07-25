package ldb.groupware.dto.board;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@ToString
@Setter
public class QnaFormDto {

    private Integer qnaId;
    @NotEmpty(message = "제목은 입력해야죠")
    private String qnaTitle;
    
    @Size(min = 8 , message = "8 자리 이상은 입력바람")
    private String qnaContent;
    private String memId;
    private String memName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
