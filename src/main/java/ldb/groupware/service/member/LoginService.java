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

        System.out.println(" 로그인 : " + id);
        System.out.println("입력한 비밀번호: " + password);
        System.out.println("저장된 비밀번호: " + pass);

        String memStatus = memberMapper.getMemStatus(id);
        System.out.println("상태: " + memStatus);
        if (!"Active".equals(memStatus)) {
            System.out.println("퇴직자 처리: Resigned 반환");
            return "Resigned";
        }

        if (pass != null) {
            try {
                boolean match = BCrypt.checkpw(password, pass);
                System.out.println("checkpw 결과: " + match);
            } catch (IllegalArgumentException e) {
                System.out.println("checkpw 예외 발생: " + e.getMessage());
            }
        } else {
            System.out.println("해당 ID에 대한 비밀번호 없음");
        }

        if (pass == null || !BCrypt.checkpw(password, pass)) {
            return null;
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
