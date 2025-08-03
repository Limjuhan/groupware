package ldb.groupware.mapper.mybatis.annual;

import ldb.groupware.domain.AnnualLeave;
import ldb.groupware.domain.Member;
import ldb.groupware.dto.admin.UpdateAnnualDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AnnualLeaveMapper {

    void insertAnnualLeave(AnnualLeave annualLeave);

    void updateAnnualLeave(AnnualLeave annualLeave);

    AnnualLeave selectAnnualLeave(@Param("memId") String memId,@Param("hireYear") int hireYear);

    int updateAnnualLeaveByDashboard(@Param("dto") UpdateAnnualDto dto,
                                      @Param("loginId") String loginId);
}
