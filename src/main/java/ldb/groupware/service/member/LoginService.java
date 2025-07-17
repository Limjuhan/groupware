package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final MemberMapper memberMapper;

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
        return memberMapper.selectLoginUser(id, password);
    }

    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
