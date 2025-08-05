package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

    private final MemberMapper memberMapper;

    public LoginService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    // 로그인
    public String login(LoginDto dto) {
        String id = dto.getId();
        String password = dto.getPassword();

        String pass = memberMapper.checkPw(id);

        if (pass == null || !BCrypt.checkpw(password, pass)) {
            return null;
        }

        String memStatus = memberMapper.getMemStatus(id);

        if (!"Active".equals(memStatus)) {
            return "Resigned";
        }

        return id;
    }


    // 로그아웃
    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}