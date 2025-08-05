package ldb.groupware.dto.board;

import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class NoticeUpdateDto {

    private Integer noticeId;

    @Size(min = 1, message = "제목은 입력 필수입니다.")
    private String noticeTitle;

    private String noticeContent;
    private String memId;
    private String memName;
    private List<String> existingFiles;
    private Integer noticeCnt;
    private Character isPinned;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
