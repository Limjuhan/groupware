package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FaqMapper {

    public List<FaqListDto> findFaqList(PaginationDto dto);

    int faqCount();

    int insertFaq(FaqFormDto dto);

    FaqFormDto findById(int faqId);

    List<DeptDto> deptAll();

    int updateFaq(FaqFormDto dto);

    int deleteFaq(int i);

    List<DeptDto> findDept();

    List<FaqListDto> findList(int i);
}
