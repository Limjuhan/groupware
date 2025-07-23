package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.dto.member.MemberAnnualLeaveDto;
import ldb.groupware.dto.member.MemberAnnualLeaveHistoryDto;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.member.DeptDto;
import ldb.groupware.dto.member.MemberListDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.dto.member.RankDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    String loginId(@Param("id") String id,
                   @Param("password") String password);

    MemberUpdateDto selectInfo(String memId);

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

    void insertAttach(AttachmentDto attach);

    int updateInfo(MemberUpdateDto dto);

    MemberAnnualLeaveDto selectAnnualByMemId(@Param("memId") String memId);

    List<MemberAnnualLeaveHistoryDto> selectAnnualLeaveHistory(String memId);
}
