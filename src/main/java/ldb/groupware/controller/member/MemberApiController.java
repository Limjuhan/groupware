package ldb.groupware.controller.member;

import jakarta.validation.Valid;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.member.CodeDto;
import ldb.groupware.dto.member.PwCodeDto;
import ldb.groupware.dto.member.ResetPwDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/member")
public class MemberApiController {

    private final MemberService memberService;

    public MemberApiController(MemberService memberService) {
        this.memberService = memberService;
    }

    // 인증메일 전송
    @PostMapping("sendCode")
    public ResponseEntity<ApiResponseDto<Void>> sendCode(@Valid @ModelAttribute("pwCodeDto") PwCodeDto dto) {
        return memberService.sendCode(dto);
    }

    // 인증번호 확인
    @PostMapping("verifyCode")
    public ResponseEntity<ApiResponseDto<Void>> verifyCode(@Valid @ModelAttribute("CodeDto") CodeDto dto) {
        return memberService.verifyCode(dto);
    }


    @PostMapping("sendTemp")
    public ResponseEntity<ApiResponseDto<Void>> sendTemp(@RequestParam String memId) {
        return memberService.sendTemp(memId);
    }

    // 비밀번호 재설정
    @PostMapping("resetPw")
    public ResponseEntity<ApiResponseDto<Void>> resetPw(@Valid @ModelAttribute("resetPwDto") ResetPwDto dto) {
        return memberService.resetPw(dto);
    }
}
