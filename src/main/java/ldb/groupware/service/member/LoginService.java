package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginService {

    private final MemberMapper memberMapper;

    public boolean loginChk(HttpServletRequest request) {
        String login = (String) request.getSession().getAttribute("login");
        if (login != null) {
            request.getSession().invalidate();
            return false;
        } else {
            request.setAttribute("error", "로그아웃하세요");
            return true;
        }

    }


    public LoginUserDto getLoginUserDto(String id, String password) {
        return memberMapper.selectLoginUser(id, password);
    }
}
