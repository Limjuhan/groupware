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


    public String getUpdatedAtStr(){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return formatter.format(updatedAt);
    }
}
