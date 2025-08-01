package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftUpdateDto {
    private Integer docId; // 문서Id
    private Integer status; // 결재상태
    private String action; // 제출구분(결재or반려)
    private String comment; // 결재시 내용
    private String formCode; // 결재양식

    private double requestDays;// 연차 사용일수
}
