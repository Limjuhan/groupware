package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.member.MemberInfoDto;
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

    @GetMapping("searchMembers")
    public Map<String, Object> searchMembers(@ModelAttribute PaginationDto paginationDto,
                                             @RequestParam(required = false) String dept,
                                             @RequestParam(required = false) String rank,
                                             @RequestParam(required = false) String name,
                                             HttpSession session) {
        // 로그인 ID는 추후 사용 가능
        // String loginId = (String) session.getAttribute("loginId");
        log.debug("📥 페이지 요청 들어옴: {}", paginationDto.getPage());
        return memberService.getMembers(paginationDto, dept, rank, name);
    }

    @PostMapping("updateMemberByMng")
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(@RequestBody Map<String, String> map) {
        return memberService.updateMemberByMng(
                map.get("memId"),
                map.get("deptId"),
                map.get("rankId")
        );
    }

    @GetMapping("getMemberInfo")
    public ResponseEntity<ApiResponseDto<MemberInfoDto>> getMemberInfo(@RequestParam String memId) {

        MemberInfoDto memberInfo = memberService.getInfo(memId);
        if (memberInfo == null) {
            return ApiResponseDto.fail("사원 정보를 찾을 수 없습니다.");
        }
        return ApiResponseDto.ok(memberInfo, "사원 정보 조회 성공");
    }
}