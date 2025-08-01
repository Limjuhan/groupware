package ldb.groupware.dto.board;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
public class FaqFormDto {

    private int faqId;
    @NotEmpty(message = "제목을 입력하세요")
    private String faqTitle;
    @NotEmpty(message = "내용을 입력하세요")
    private String faqContent;
    @NotEmpty(message = "부서를 선택하세요")
    private String deptId;
    private String deptName;
    private int page;
}
