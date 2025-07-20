package ldb.groupware.dto.board;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NoticeListDto {

    private Integer noticeId;
    private String noticeTitle;
    private String memId;
    private String memName;
    private Integer noticeCnt;
    private String isPinned;
    private LocalDateTime updatedAt;
}
