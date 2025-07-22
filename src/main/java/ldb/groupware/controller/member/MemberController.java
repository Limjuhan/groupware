package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    //  개인정보 조회 화면
    @GetMapping("memberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto dto = memberService.getInfo(loginId);
        model.addAttribute("user", dto);
        return "member/memberInfo";
    }

    // 비밀번호 수정 폼
    @GetMapping("passEditForm")
    public String getPassEditForm() {
        return "member/passEditForm";
    }

    //  개인정보 수정 처리
    @PostMapping("updateMemberInfo")
    public String updateMemberInfo(@Valid @ModelAttribute MemberUpdateDto dto,
                                   BindingResult bresult,
//                                   @RequestParam(value = "photo", required = false) MultipartFile photo,
                                   HttpSession session,
                                   Model model) {
        if (bresult.hasErrors()) return "member/memberInfo";

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        boolean result = memberService.updateInfo(loginId, dto);

        model.addAttribute("msg", result ? "수정 성공" : "수정 실패");
        model.addAttribute("url", "member/memberInfo");
        return "alert";
    }
}
