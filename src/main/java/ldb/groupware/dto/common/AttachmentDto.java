package ldb.groupware.dto.common;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class AttachmentDto {
    private Integer attachId;
    private String businessId;
    private String attachType;
    private String originalName;
    private String savedName;
    private String filePath;
    private LocalDateTime createdAt;
}
