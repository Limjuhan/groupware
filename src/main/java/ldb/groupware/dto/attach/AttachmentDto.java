package ldb.groupware.dto.attach;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AttachmentDto {

    private Integer attachId;
    private String businessId;
    private String attachType;
    private String originalName; //원본명
    private String savedName; //저장명(UUID)
    private String filePath; // 경로
    private LocalDateTime createdAt;
}
