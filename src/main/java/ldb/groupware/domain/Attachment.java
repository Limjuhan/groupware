package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class Attachment {
    private Integer attachId;
    private Integer businessId;
    private String attachType;
    private String originalName;
    private String savedName;
    private String filePath;
    private String createdAt;

    public void setData(Integer businessId, String attachType, String originalName, String savedName, String filePath) {
        this.businessId = businessId;
        this.attachType = attachType;
        this.originalName = originalName;
        this.savedName = savedName;
        this.filePath = filePath;
        this.createdAt = LocalDateTime.now().toString();
    }
}

