package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.dto.member.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    String checkPw(@Param("memId") String memId);

    String getMemStatus(@Param("memId") String memId);


    List<MemberAnnualLeaveHistoryDto> selectAnnualLeaveHistory(String memId);

    int countMembers(MemberSearchDto dto);

    List<MemberListDto> getPagedMembers(MemberSearchDto dto);

    List<DeptDto> getDeptList();

    List<RankDto> getRankList();

    String nextMemId(@Param("year") String year);

    int insertMember(Map<String, Object> map);

    int updateMemberByMng(UpdateMemberDto dto);

    int updateInfo(MemberUpdateDto dto);

    int changePw(@Param("memId") String memId, @Param("encodedPassword") String encodedPassword);


    MemberInfoDto selectMemberInfo(String memId);

    String findNameById(String id);
}