package ldb.groupware.domain;

import lombok.Data;

@Data
public class Attachment {
    /*
    * 파일을 저장하고있는 클래스
    * */

    private Integer attachId;
    private Integer businessId;
    private String attachType;
    private String faqContent;
    private String createdAt;  // text 타입이므로 String 처리
    private String updatedAt;  // text 타입이므로 String 처리
}

