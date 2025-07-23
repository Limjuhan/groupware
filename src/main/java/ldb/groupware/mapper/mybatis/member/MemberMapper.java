package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.dto.member.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    String getPasswordByMemId(@Param("memId") String memId);

    String getMemStatus(@Param("memId") String memId);

    String getJuminBackByMemId(@Param("memId") String memId);

    MemberUpdateDto selectInfo(String memId);

    List<MemberAnnualLeaveHistoryDto> selectAnnualLeaveHistory(String memId);

    int countMembers(@Param("dept") String dept,
                     @Param("rank") String rank,
                     @Param("name") String name);

    List<MemberListDto> getPagedMembers(@Param("dept") String dept,
                                        @Param("rank") String rank,
                                        @Param("name") String name,
                                        @Param("start") int start,
                                        @Param("limit") int limit);

    List<DeptDto> getDeptList();

    List<RankDto> getRankList();

    String nextMemId(@Param("year") String year);

    int insertMember(Map<String, Object> map);

    int updateMemberByMng(@Param("memId") String memId,
                          @Param("deptId") String deptId,
                          @Param("rankId") String rankId);

    int updateInfo(MemberUpdateDto dto);

    int updatePassword(@Param("memId") String memId, @Param("encodedPassword") String encodedPassword);

    MemberAnnualLeaveDto selectAnnualByMemId(String memId);
}