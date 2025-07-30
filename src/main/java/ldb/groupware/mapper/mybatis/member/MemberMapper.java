package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.domain.Member;
import ldb.groupware.dto.member.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

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

    int insertMember(MemberFormDto dto);

    int updateMemberByMng(UpdateMemberDto dto);

    int updateInfo(MemberUpdateDto dto);

    int changePw(@Param("memId") String memId, @Param("encodedPassword") String encodedPassword);

    MemberInfoDto selectMemberInfo(String memId);

    String findNameById(String id);

    boolean isValidMember(PwCodeDto dto);

    String selectEmail(@Param("memId") String memId);

    List<Member> findAllActiveMembers();

    List<MemberListDto> getMemberList();

    AuthDto selectAuth(@Param("loginId") String loginId);
}