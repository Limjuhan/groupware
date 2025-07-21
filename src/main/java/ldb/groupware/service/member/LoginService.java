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

    // 로그인 처리: 로그인 ID만 반환
    public String login(String id, String password) {
        return memberMapper.loginId(id, password); // null이면 로그인 실패
    }

    // 로그아웃 처리
    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
    }
}
