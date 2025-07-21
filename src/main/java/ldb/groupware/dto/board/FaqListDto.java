package ldb.groupware.dto.board;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FaqListDto {
    private String faqId;
    private String deptId;
    private String faqTitle;
    private String faqContent;
    private String deptName;
}
