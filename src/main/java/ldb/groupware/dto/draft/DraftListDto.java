package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftListDto {
    private String docId; //문서ID
    private String docTitle; //문서제목
    private String docEndDate; //문서 종료일
    private String writer; //기안자
    private String approver1; //1차결재자ID
    private String approver2; //2차결재자ID
    private String status; //결재진행단계
}
