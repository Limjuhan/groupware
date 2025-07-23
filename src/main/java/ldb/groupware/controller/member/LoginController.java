package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.service.member.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/login")
@RequiredArgsConstructor
public class LoginController {

    private final LoginService loginService;

    // 로그인 화면
    @GetMapping("doLogin")
    public String doLogin() {
        return "login/doLogin";
    }

    // 로그인 처리
    @PostMapping("loginProcess")
    public String loginProcess(@RequestParam String id,
                               @RequestParam String password,
                               HttpSession session,
                               Model model) {

        String loginId = loginService.login(id, password);

        if (loginId == null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "login/doLogin";
        }

        session.setAttribute("loginId", loginId);
        session.setMaxInactiveInterval(180 * 60);
        return "redirect:/";
    }

    // 로그아웃 처리
    @GetMapping("doLogout")
    public String doLogout(HttpServletRequest request) {
        loginService.logout(request);
        return "redirect:/login/doLogin";
    }

    @GetMapping("findPass")
    public String findPass() {
        return "login/findPass";
    }
}
