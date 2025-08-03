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
}
