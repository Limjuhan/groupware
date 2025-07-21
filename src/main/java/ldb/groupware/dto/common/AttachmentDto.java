package ldb.groupware.dto.common;

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
    private LocalDateTime createdAt;  // text 타입이므로 String 처리
}
