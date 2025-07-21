package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    //  개인정보 조회 화면
    @GetMapping("getMemberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberInfoDto dto = memberService.getInfo(loginId);
        model.addAttribute("user", dto);
        return "member/getMemberInfo";
    }

    // 비밀번호 수정 폼
    @GetMapping("getPassEditForm")
    public String getPassEditForm() {
        return "member/getPassEditForm";
    }

    //  개인정보 수정 처리
    @PostMapping("updateMemberInfo")
    public String updateMemberInfo(@Valid @ModelAttribute MemberUpdateDto dto,
                                   BindingResult bresult,
                                   @RequestParam(value = "photo", required = false) MultipartFile photo,
                                   HttpSession session,
                                   Model model) {
        if (bresult.hasErrors()) return "member/getMemberInfo";

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        boolean result = memberService.updateInfo(loginId, dto, photo);

        model.addAttribute("msg", result ? "수정 성공" : "수정 실패");
        model.addAttribute("url", "getMemberInfo");
        return "alert";
    }
}
