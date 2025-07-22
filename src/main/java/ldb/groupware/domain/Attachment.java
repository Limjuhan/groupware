package ldb.groupware.domain;

import lombok.Data;

@Data
public class Attachment {
    private Integer attachId;
    private Integer businessId;
    private String attachType;
    private String originalName;
    private String savedName;
    private String filePath;
    private String createdAt;

}

