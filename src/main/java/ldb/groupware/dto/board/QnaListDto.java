package ldb.groupware.dto.board;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class QnaListDto {

    private Integer qnaId;
    private String qnaTitle;
    private String qnaContent;
    private String memId;
    private String memName;
    private int viewCount;
    private LocalDateTime updatedAt;
    private String dateFormat;

    //LocaldateTime--> string
    public void setDateFormat(){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.dateFormat =  this.updatedAt.format(formatter);
    }
}
