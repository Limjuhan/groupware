package ldb.groupware.dto.alarm;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AlarmDto {
    private String memId;
    private Integer docId;
    private String readYn;
}
