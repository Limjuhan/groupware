package ldb.groupware.mapper.mybatis.annual;

import ldb.groupware.domain.AnnualLeave;
import ldb.groupware.domain.Member;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AnnualLeaveMapper {

    AnnualLeave selectByMemIdAndYear(@Param("memId") String memId, @Param("year") int year);

    boolean existsByMemIdAndYear(@Param("memId") String memId, @Param("year") int year);

    void insertAnnualLeave(AnnualLeave annualLeave);

    void updateAnnualLeave(AnnualLeave annualLeave);

    List<Member> findAllActiveMembers();
}
