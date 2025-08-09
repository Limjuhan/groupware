package ldb.groupware.dto.common;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommonCodeDto {
    private String codeGroup;
    private String codeId;
    private String codeName;
    private String useYn; // 'Y' or 'N'

    public String getCodeGroupName(String codeGroup) {
        switch (codeGroup) {
            case "approval_status":
                return "결재대기상태";

            case "approval_type":
                return "결재양식";

            case "attach_type":
                return "첨부파일타입";

            case "fac_type":
                return "공용설비 타입";

            case "leave_type":
                return "휴가신청 타입";

            case "mem_status":
                return "재직여부";

            default:
                return "정의되지않은 코드";
        }
    }

}
