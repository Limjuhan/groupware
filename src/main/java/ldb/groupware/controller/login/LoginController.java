package ldb.groupware.controller.login;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/login")
public class LoginController {
    @GetMapping("dologin")
    public String dologin(){
        return "login/dologin";
    }

    @PostMapping("loginProcess")
    public String loginProcess(@RequestParam String id, @RequestParam String password , HttpSession session) {

        return   "login/dologin";
    }
}
