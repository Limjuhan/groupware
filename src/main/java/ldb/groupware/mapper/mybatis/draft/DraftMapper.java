package ldb.groupware.mapper.mybatis.draft;

import ldb.groupware.dto.draft.DraftListDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DraftMapper {

    List<DraftListDto> getMyDraftList(@Param("memId") String memId,
                                         @Param("type") String type,
                                         @Param("keyword") String keyword);

}
