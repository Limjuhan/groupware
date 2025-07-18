package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ApprovalInfoDto {
    private int docId;
    private String formCode;
    private String docTitle;
    private String memName;
    private String docContent;
    private String docEndDate;
    private int status;

    public String getformCodeText() {
        return switch (formCode) {
            case "app_01" -> "휴가 신청서";
            case "app_02" -> "프로젝트제안서";
            case "app_03" -> "지출결의서";
            case "app_04" -> "사직서";
            default -> "양식코드 없음";
        };
    }

    public String getStatusText() {
        return switch (status) {
            case 0 -> "임시저장";
            case 1 -> "1차결재 대기";
            case 2 -> "1차결재 승인";
            case 3 -> "1차결재 반려";
            case 4 -> "2차결재 대기";
            case 5 -> "2차결재 승인";
            case 6 -> "2차결재 반려";
            default -> "임시저장";
        };
    }
}
