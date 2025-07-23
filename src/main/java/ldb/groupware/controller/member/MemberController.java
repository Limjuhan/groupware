package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberAnnualLeaveDto;
import ldb.groupware.dto.member.MemberAnnualLeaveHistoryDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    //   개인정보 조회 화면
    @GetMapping("memberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/login/doLogin";

        MemberAnnualLeaveDto annual = memberService.getAnnualInfo(loginId);
        MemberUpdateDto dto = memberService.getInfo(loginId);
        List<MemberAnnualLeaveHistoryDto> annualHistoryList = memberService.getAnnualLeaveHistory(loginId);

        model.addAttribute("user", dto);
        model.addAttribute("annual", annual);
        model.addAttribute("annualHistoryList", annualHistoryList);

        return "member/memberInfo";
    }


    // 비밀번호 변경
    @GetMapping("passEditForm")
    public String getPassEditForm() {
        return "member/passEditForm";
    }

    @PostMapping("updateMemberInfo")
    public String updateMemberInfo(@Valid @ModelAttribute("user") MemberUpdateDto dto,
                                   BindingResult bindingResult,
                                   HttpSession session,
                                   Model model) {
        if (bindingResult.hasErrors()) {
            return "member/memberInfo";
        }

        String loginId = (String) session.getAttribute("loginId");

        dto.setMemId(loginId);
        boolean success = memberService.updateInfo(dto);

        model.addAttribute("msg", success ? "수정 성공" : "수정 실패");
        model.addAttribute("url", "/member/memberInfo");
        return "alert";
    }
}
