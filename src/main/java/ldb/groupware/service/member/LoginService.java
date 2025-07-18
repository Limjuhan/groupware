package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class LoginService {

    private final MemberMapper memberMapper;

    public LoginService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

//    public boolean loginChk(HttpServletRequest request) {
//        LoginUserDto loginUser = (LoginUserDto) request.getSession().getAttribute("loggedInUser");
//        if (loginUser != null) {
//            return false;
//        } else {
//            return false;
//        }
//
//    }

    public LoginUserDto getLoginUserDto(String id, String password) {
        LoginUserDto loginUserDto = memberMapper.selectLoginUser(id, password);

        if (loginUserDto != null) {
            loginUserDto.BirthDate();
        }
        return loginUserDto;
    }

    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

}