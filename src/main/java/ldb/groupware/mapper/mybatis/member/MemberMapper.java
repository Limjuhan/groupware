package ldb.groupware.mapper.mybatis.member;

import ldb.groupware.dto.member.LoginUserDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    LoginUserDto selectLoginUser(String id, String password);
}
