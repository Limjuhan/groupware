package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.service.member.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/login")
@RequiredArgsConstructor
public class LoginController {

    private final LoginService service;

    @GetMapping("dologin")
    public String dologin(HttpServletRequest request) {
        if (service.loginChk(request)) {
            return "error";
        }
        return "login/dologin";
    }

    @PostMapping("/loginProcess")
    public String loginProcess(@RequestParam String id,
                               @RequestParam String password,
                               HttpSession session, HttpServletRequest request) {

        LoginUserDto loginUser  = service.getLoginUserDto(id,password);
        if (loginUser == null) {
            request.setAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "login/dologin";
        }
        session.setAttribute("loggedInUser", loginUser);
        session.setMaxInactiveInterval(30 * 60);
        return "redirect:/";
    }
}
