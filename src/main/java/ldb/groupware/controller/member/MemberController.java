package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.service.member.MemberServie;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberServie servie;

    @GetMapping("getMemberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("loggedInUser");

        if (loginUser == null) {
            return "redirect:/login/doLogin";
        }

        model.addAttribute("user", loginUser);
        return "member/memberInfo";
    }
}
