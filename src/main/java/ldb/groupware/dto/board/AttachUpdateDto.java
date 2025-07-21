package ldb.groupware.dto.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.bind.annotation.GetMapping;

@Getter
@Setter
@ToString
public class AttachUpdateDto {

    private String businessId;
    private String fileName;
}
