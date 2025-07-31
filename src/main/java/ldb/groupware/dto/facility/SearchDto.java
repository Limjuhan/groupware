package ldb.groupware.dto.facility;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

@Getter
@Setter
@ToString
public class SearchDto {

    private String rentYn;
    private String facType;
    private String yearMonth;
    private boolean includeCancel; // 취소여부판단 (true:취소포함 )


    public String getRentYn() {
        if (StringUtils.isBlank(this.rentYn)) {
            return null;
        } else {
            return this.rentYn;
        }
    }
}
