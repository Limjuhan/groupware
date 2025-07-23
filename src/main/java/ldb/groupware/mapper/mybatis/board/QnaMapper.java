package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.board.QnaListDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface QnaMapper {
    int countQna();

    List<QnaListDto> getQnaList(PaginationDto paging);
}
