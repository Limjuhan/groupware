package ldb.groupware.dto.alarm;

import ldb.groupware.dto.draft.ApprovalConst;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AlarmInfoDto {
    private String formCode;
    private int docId;
    private String docTitle;
    private int stepOrder; // 0:기안자/1:1차결재자/2차결재자/3:참조자
    private int status;// 결재대기상태
    private String url;
    private String writer;
    private String formCodeToStr;

    public String getUrl() {
        if (stepOrder == 0) {
            return "/draft/getMyDraftDetail";
        } else {
            return "/draft/receivedDraftDetail";
        }
    }

    public String getFormCodeToStr() {
        if (ApprovalConst.FORM_ANNUAL.equals(formCode)) {
            return "휴가";
        } else if (ApprovalConst.FORM_PROJECT.equals(formCode)) {
            return "프로젝트";
        } else if (ApprovalConst.FORM_EXPENSE.equals(formCode)) {
            return "지출";
        } else if (ApprovalConst.FORM_RESIGN.equals(formCode)) {
            return "사직";
        }
        return "양식정보없음";
    }

}



