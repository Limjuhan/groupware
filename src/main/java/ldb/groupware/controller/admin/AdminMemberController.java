package ldb.groupware.controller.admin;

import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminMemberController {

    private final MemberService memberService;

    public AdminMemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping("getMemberList")
    public String getMemberList(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/getMemberList";
    }

    @GetMapping("getMemberForm")
    public String getMemberForm(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/getMemberForm";
    }


}
