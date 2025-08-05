package ldb.groupware.dto.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


@Getter
@Setter
@ToString
public class QnaDetailDto {
    private Integer qnaId;
    private String qnaTitle;

    private String qnaContent;
    private String memId;
    private String memName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createFormat;
    private String updateFormat;

    //LocaldateTime--> string
    public void formatDates(){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.updateFormat =  this.updatedAt.format(formatter);
        this.createFormat = this.createdAt.format(formatter);
    }

}
