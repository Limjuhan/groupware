package ldb.groupware.mapper.mybatis.draft;

import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.dto.draft.DraftForMemberDto;
import ldb.groupware.dto.draft.DraftFormDto;
import ldb.groupware.dto.draft.DraftListDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DraftMapper {

    List<DraftListDto> getMyDraftList(@Param("memId") String memId,
                                         @Param("type") String type,
                                         @Param("keyword") String keyword);

    List<DraftForMemberDto> getMemberList();

    Integer getReaminAnnual(@Param("memId") String memId);

    void insertApprovalDocument(@Param("dto") DraftFormDto dto, @Param("memId") String memId);

    void insertFormAnnualLeave(FormAnnualLeave formAnnualLeave);

}
