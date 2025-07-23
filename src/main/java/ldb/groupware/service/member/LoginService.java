package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

    private final MemberMapper memberMapper;

    public LoginService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    public String login(String id, String password) {
        String pass = memberMapper.getPasswordByMemId(id);
        if (pass == null || !BCrypt.checkpw(password, pass)) {
            return null;
        }
        String memStatus = memberMapper.getMemStatus(id);
        if (!"재직".equals(memStatus)) {
            return null;
        }
        return id;
    }

    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
