package ldb.groupware.dto.board;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class NoticeListDto {

    private Integer noticeId;
    private String noticeTitle;
    private String memId;
    private String memName;
    private Integer noticeCnt;
    private String isPinned;
    private LocalDateTime updatedAt;
    private String dateFormat;

    //LocaldateTime--> string
    public void updatedAtToString(){
         DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
         this.dateFormat =  this.updatedAt.format(formatter);
    }
    public String getUpdatedAtToStr(){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return formatter.format(updatedAt);
    }
}
