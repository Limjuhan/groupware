package ldb.groupware.dto.draft;

public class ApprovalConst {

    public static final String FORM_ANNUAL = "app_01";
    public static final String FORM_PROJECT = "app_02";
    public static final String FORM_EXPENSE = "app_03";
    public static final String FORM_RESIGN = "app_04";

    public static final String REF_YES = "Y";
    public static final String REF_NO = "N";

    public static final int STATUS_TEMP = 0; // 임시저장
    public static final int STATUS_FIRST_APPROVAL_WAITING = 1; // 1차결재대기
    public static final int STATUS_FIRST_APPROVAL_APPROVED = 2; // 1차결재승인
    public static final int STATUS_FIRST_APPROVAL_REJECTED = 3; // 1차결재반려
    public static final int STATUS_SECOND_APPROVAL_WAITING = 4; // 2차결재대기
    public static final int STATUS_SECOND_APPROVAL_APPROVED = 5; // 2차결재승인
    public static final int STATUS_SECOND_APPROVAL_REJECTED = 6; // 2차결재반려


    public static final String ACTION_APPROVE = "approve";
    public static final String ACTION_REJECT = "reject";
}

