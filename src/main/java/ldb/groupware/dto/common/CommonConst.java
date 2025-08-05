package ldb.groupware.dto.common;

public enum CommonConst {

    ATTACH_TYPE("attach_type","첨부파일등록하는위치에따른 첨부파일타입"),
    APPROVAL_TYPE("approval_type", "전자결재 양식종류"),
    APPROVAL_STATUS("approval_status", "전자결재 대기상태"),
    LEAVE_TYPE("leave_type", "휴가종류"),
    FACILITY_TYPE("fac_type", "설비종류");

    private final String value;
    private final String label;

    CommonConst(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getValue() {
        return value;
    }
    public String getLabel() { return label; }
}
