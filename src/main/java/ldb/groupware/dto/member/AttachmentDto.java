package ldb.groupware.dto.member;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
public class AttachmentDto {
    private Integer attachId;
    private String businessId;     // memId
    private String attachType;     // 'P'
    private String originalName;
    private String savedName;
    private String filePath;
    private LocalDate createdAt;
}
