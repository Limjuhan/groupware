package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.member.LoginDto;
import ldb.groupware.service.member.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/login")
@RequiredArgsConstructor
public class LoginController {

    private final LoginService loginService;

    // 로그인 페이지 요청
    @GetMapping("doLogin")
    public String doLogin(Model model) {
        model.addAttribute("loginDto", new LoginDto());
        return "login/doLogin";
    }

    // 로그인 처리
    @PostMapping("loginProcess")
    public String loginProcess(@Valid @ModelAttribute("loginDto") LoginDto loginDto,
                               BindingResult bindingResult,
                               HttpSession session,
                               Model model) {

        if (bindingResult.hasErrors()) {
            return "login/doLogin";
        }

        String loginId = loginService.login(loginDto);

        if (loginId == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("url", "/login/doLogin");
            return "alert";
        }

        session.setAttribute("loginId", loginId);
        session.setMaxInactiveInterval(180 * 60); // 3시간
        return "redirect:/";
    }

    // 로그아웃 처리
    @GetMapping("doLogout")
    public String doLogout(HttpServletRequest request) {
        loginService.logout(request);
        return "redirect:/login/doLogin";
    }

    // 비밀번호 찾기
    @GetMapping("findPass")
    public String findPass() {
        return "login/findPass";
    }
}
