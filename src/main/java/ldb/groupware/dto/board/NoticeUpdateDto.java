package ldb.groupware.dto.board;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NoticeUpdateDto {

    private Integer noticeId;

    @Size( min = 1, message = "제목은 필수입니다.")
    private String noticeTitle;

    private String noticeContent;
    private String memId;
    private String memName;
    private String[] existingFiles;
    private Integer noticeCnt;
    private Character isPinned;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
