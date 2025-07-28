package ldb.groupware.dto.facility;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

import java.util.Date;

@Getter
@Setter
@ToString
public class SearchDto {

    private String rentYn;
    private String facType;
    private String yearMonth;

    public String getRentYn() {
        if(StringUtils.isBlank(this.rentYn)){
            return null;
        }
        else{
            return this.rentYn;
        }
    }
}
