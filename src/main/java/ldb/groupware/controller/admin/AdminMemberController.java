package ldb.groupware.controller.admin;

import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberFormDto;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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

    @PostMapping("insertMemberByMng")
    public String insertMemberByMng(@Valid @ModelAttribute MemberFormDto dto, BindingResult bresult, Model model) {
        if (bresult.hasErrors()) {
            model.addAttribute("deptList", memberService.getDeptList());
            model.addAttribute("rankList", memberService.getRankList());
            return "admin/getMemberForm";
        }

        boolean success = memberService.insertMember(dto);

        if (success) {
            model.addAttribute("url", "/admin/getMemberList");
        } else {
            model.addAttribute("msg", "사원 등록 실패");
            model.addAttribute("url", "/admin/getMemberForm");
        }

        return "alert";
    }

}
