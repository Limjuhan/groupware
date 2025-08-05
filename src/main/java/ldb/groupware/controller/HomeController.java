package ldb.groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // 루트 URL 접속 시 → 로그인 페이지로
    @GetMapping("/")
    public String root() {
        return "redirect:/login/doLogin";
    }

    // 로그인 성공 후 홈 화면
    @GetMapping("/home")
    public String home() {
        return "home"; // /WEB-INF/views/home.jsp
    }

    @GetMapping("/error-test")
    public String errorTest() {
        throw new RuntimeException("테스트용 예외 발생!");
    }
}
