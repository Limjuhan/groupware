package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

    private final MemberService service;

    public MemberController(MemberService memberService) {
        this.service = memberService;
    }

    @GetMapping("getMemberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("loggedInUser");

        if (loginUser == null) {
            return "redirect:/login/doLogin";
        }
        model.addAttribute("user", loginUser);
        return "member/getMemberInfo";
    }

    @GetMapping("getPassEditForm")
    public String getPassEditForm(HttpSession session, Model model) {
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("loggedInUser");
        model.addAttribute("user", loginUser);
        return "member/getPassEditForm";
    }

    @GetMapping("searchMemberList")
    public String searchMemberList(HttpSession session, Model model) {
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("loggedInUser");
        if (loginUser == null) {
            return "redirect:/login/doLogin";
        }
        model.addAttribute("user", loginUser);
        return "member/searchMemberList";
    }

    @GetMapping("getMemberForm")
    public String getMemberForm(HttpSession session, Model model) {
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("loggedInUser");
        if (loginUser == null) {
            return "redirect:/login/doLogin";
        }
        model.addAttribute("user", loginUser);
        return "member/getMemberForm";
    }
}
