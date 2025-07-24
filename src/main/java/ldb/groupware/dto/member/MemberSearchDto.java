package ldb.groupware.dto.member;

import ldb.groupware.dto.board.PaginationDto;
import lombok.Data;

@Data
public class MemberSearchDto extends PaginationDto {
    private String dept;
    private String rank;
    private String name;
}

