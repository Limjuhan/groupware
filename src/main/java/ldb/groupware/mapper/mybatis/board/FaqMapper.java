package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.board.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FaqMapper {

    public List<FaqListDto> findFaqList(PaginationDto dto);

    int faqCount();
}
