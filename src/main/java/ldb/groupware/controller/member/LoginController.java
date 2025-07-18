package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.service.member.LoginService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/login")
public class LoginController {

    private final LoginService service;

    public LoginController(LoginService service) {
        this.service = service;
    }

    @GetMapping("doLogin")
    public String doLogin() {
        return "login/doLogin";
    }

    @PostMapping("loginProcess")
    public String loginProcess(@RequestParam String id,
                               @RequestParam String password,
                               HttpSession session, HttpServletRequest request) {

        LoginUserDto loginUser = service.getLoginUserDto(id, password);
        if (loginUser == null) {
            request.setAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "login/doLogin";
        }
        session.setAttribute("loggedInUser", loginUser);
        session.setMaxInactiveInterval(180 * 60);
        return "redirect:/";
    }

    @GetMapping("doLogout")
    public String doLogout(HttpServletRequest request) {
        service.logout(request);
        return "redirect:/login/doLogin";
    }
}
