package ldb.groupware.dto.board;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NoticeUpdateDto {

    private Integer noticeId;
    private String noticeTitle;
    private String noticeContent;
    private String memId;
    private String memName;
    private String existingFiles;
    private Integer noticeCnt;
    private Character isPinned;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
