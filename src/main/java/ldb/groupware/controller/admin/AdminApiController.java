package ldb.groupware.controller.admin;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberSearchDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminApiController {

    private final MemberService memberService;

    public AdminApiController(MemberService memberService) {
        this.memberService = memberService;
    }

    // 사원 목록
    @GetMapping("searchMembers")
    public Map<String, Object> searchMembers(@ModelAttribute MemberSearchDto searchDto) {
        return memberService.getMembers(searchDto);
    }
    
    // 사원 설정(모달 - 직급,부서 설정)
    @PostMapping("updateMemberByMng")
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(@RequestBody UpdateMemberDto dto) {
        return memberService.updateMemberByMng(dto);
    }
    
    // 사원목록 (모달 - 사원정보)
    @GetMapping("getMemberInfo")
    public ResponseEntity<ApiResponseDto<MemberInfoDto>> getMemberInfo(@RequestParam String memId) {
        MemberInfoDto info = memberService.getMemberInfo(memId);
        if (info == null) {
            return ApiResponseDto.fail("사원 정보를 찾을 수 없습니다.");
        }
        return ApiResponseDto.ok(info, "사원 정보 조회 성공");
    }


}