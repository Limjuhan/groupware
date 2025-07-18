package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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

    public String login(String id, String password) {
        return memberMapper.loginId(id, password);
    }

    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
