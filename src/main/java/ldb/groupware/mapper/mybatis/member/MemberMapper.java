package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.domain.Member;
import ldb.groupware.dto.member.DeptDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberListDto;
import ldb.groupware.dto.member.RankDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    String loginId(@Param("id") String id,
                   @Param("password") String password);

    MemberInfoDto selectInfo(String memId);

    int updateInfo(@Param("memId") String memId,
                   @Param("phone") String phone,
                   @Param("privateEmail") String privateEmail,
                   @Param("address") String address);

//    int deletePhoto(String memId);
//
//    int insertPhoto(AttachmentDto dto);

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

}
