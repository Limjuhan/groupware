package ldb.groupware.domain;

import lombok.Data;
import java.time.LocalDateTime;

@Data
//공지사항
public class Notice {

    private Integer noticeId;
    private String noticeTitle;
    private String noticeContent;
    private String memId;
    private Integer noticeCnt;
    private String isPinned;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

