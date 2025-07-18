package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService service;

    @GetMapping("getMemberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto user = service.getMemberInfo(loginId);
        model.addAttribute("user", user);
        return "member/getMemberInfo";
    }

    @GetMapping("getPassEditForm")
    public String getPassEditForm(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto user = service.getMemberInfo(loginId);
        model.addAttribute("user", user);
        return "member/getPassEditForm";
    }

    @GetMapping("searchMemberList")
    public String searchMemberList(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto user = service.getMemberInfo(loginId);
        model.addAttribute("user", user);
        return "member/searchMemberList";
    }

    @GetMapping("getMemberForm")
    public String getMemberForm(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto user = service.getMemberInfo(loginId);
        model.addAttribute("user", user);
        return "member/getMemberForm";
    }
}