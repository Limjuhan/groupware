package ldb.groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "home"; // → /WEB-INF/views/home.jsp 렌더링됨
    }

    @GetMapping("/error-test")
    public String errorTest() {
        throw new RuntimeException("테스트용 예외 발생!");
    }

    @GetMapping("/calendar")
    public String calendar(){
        return "getCalendar";
    }

    @GetMapping("/profile")
    public String profile(){
        return "getMemberInfo";
    }
}
