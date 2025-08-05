package ldb.groupware.dto.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NoticeDetailDto {

    private Integer noticeId;
    private String noticeTitle;
    private String noticeContent;
    private Character isPinned;
    private String memId;
    private String memName;
}
