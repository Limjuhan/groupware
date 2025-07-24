package ldb.groupware.mapper.mybatis.draft;

import jakarta.validation.constraints.NotBlank;
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

    Integer getRemainAnnual(@Param("memId") String memId);

    void insertApprovalDocument(@Param("dto") DraftFormDto dto,
                                @Param("status") Integer status,
                                @Param("memId") String memId);

    void insertFormAnnualLeave(FormAnnualLeave formAnnualLeave);

    void insertApprovalLine(@Param("docId") Integer docId,
                            @Param("memId") String memId,
                            @Param("stepOrder") int stepOrder,
                            @Param("refYn") String refYn);
}
