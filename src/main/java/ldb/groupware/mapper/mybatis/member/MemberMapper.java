package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.dto.member.MemberInfoDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    String loginId(String id,String password);
    String findMemName(String id);
    MemberInfoDto selectMemberInfo(String memId);
}
