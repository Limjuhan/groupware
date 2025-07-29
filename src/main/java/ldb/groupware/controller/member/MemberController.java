package ldb.groupware.controller.member;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberAnnualLeaveHistoryDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.dto.member.PasswordChangeDto;
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

    // 개인정보 
    @GetMapping("getMemberInfo")
    public String getMemberInfo(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            model.addAttribute("msg", "로그인이 필요합니다");
            model.addAttribute("url", "/login/doLogin");
            return "alert";
        }

        MemberInfoDto dto = memberService.getMemberInfo(loginId);
        model.addAttribute("user", dto);
        return "member/memberInfo";
    }

    // 개인 정보 수정
    @PostMapping("updateMemberInfo")
    public String updateMemberInfo(@Valid @ModelAttribute("user") MemberUpdateDto dto,
                                   BindingResult bindingResult,
                                   HttpSession session,
                                   Model model) {
        if (bindingResult.hasErrors()) {
            List<MemberAnnualLeaveHistoryDto> annualHistoryList = memberService.getAnnualLeaveHistory((String) session.getAttribute("loginId"));
            model.addAttribute("annualHistoryList", annualHistoryList);
            return "member/memberInfo";
        }

        String loginId = (String) session.getAttribute("loginId");
        dto.setMemId(loginId);
        boolean success = memberService.updateInfo(dto, loginId);

        model.addAttribute("msg", success ? "수정 성공" : "수정 실패");
        model.addAttribute("url", "/member/getMemberInfo");
        return "alert";
    }

    // 비밀번호 변경
    @GetMapping("passEditForm")
    public String getPassEditForm(Model model) {
        model.addAttribute("dto", new PasswordChangeDto());
        return "member/passEditForm";
    }

    // 비밀번호 변경 저장
    @PostMapping("UpdatePass")
    public String updatePassword(@Valid @ModelAttribute("dto") PasswordChangeDto dto,
                                 BindingResult result,
                                 HttpSession session,
                                 Model model) {
        String loginId = (String) session.getAttribute("loginId");

        if (loginId == null) return "redirect:/login/doLogin";


        // 1. 현재 비밀번호 유효성 먼저 검증
        if (!result.hasFieldErrors("curPw")) {
            boolean valid = memberService.checkPw(loginId, dto.getCurPw());
            if (!valid) {
                result.rejectValue("curPw", "password.incorrect");
            }
        }

        // 2. 현재 비번 검증 통과했을 때만 새 비밀번호 불일치 검증
        if (!result.hasFieldErrors("curPw") &&
                !dto.getNewPw().equals(dto.getChkPw())) {
            result.rejectValue("chkPw", "password.mismatch");
        }

        if (result.hasErrors()) {
            model.addAttribute("dto", dto);
            return "member/passEditForm";
        }

        boolean updated = memberService.changePw(loginId, dto.getNewPw());
        if (!updated) {
            model.addAttribute("dto", dto);
            model.addAttribute("error", "비밀번호 변경에 실패했습니다.");
            return "member/passEditForm";
        }

        model.addAttribute("msg", "비밀번호가 변경되었습니다. 다시 로그인해주세요.");
        model.addAttribute("url", "/login/doLogin");
        return "alert";
    }


}