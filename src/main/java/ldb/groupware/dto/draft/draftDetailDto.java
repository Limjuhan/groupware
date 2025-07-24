package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class draftDetailDto {
    private Integer docId;
    private String docTitle;
    private String content;
    private String writerId;
    private String formType;
    private String status;
    private LocalDate createdAt;
    private LocalDate docEndDate;
    private String approver1Name;// 1차결재자이름
    private String approver2Name;// 2차결재자이름


}
