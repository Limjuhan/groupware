package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftListDto {
    private String docId; //문서ID
    private String formCode; // 문서양식
    private String formCodeStr;
    private String docTitle; //문서제목
    private String docEndDate; //문서 종료일
    private String writer; //기안자
    private String approver1Name; //1차결재자
    private String approver2Name; //2차결재자
    private String status; //결재진행단계
    private String readYn; // 읽음여부
    private String receivedMemId; // 받은문서(읽는사원) Id

    public String getFormCodeStr() {
        switch (formCode) {
            case ApprovalConst.FORM_ANNUAL:
                return "휴가계획서";
            case ApprovalConst.FORM_PROJECT:
                return "프로젝트 제안서";
            case ApprovalConst.FORM_EXPENSE:
                return "지출결의서";
            case ApprovalConst.FORM_RESIGN:
                return "사직서";
            default:
                return "알수없는 양식";
        }
    }
}
