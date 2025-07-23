package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.member.MemberUpdateDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
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
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getMemberInfo(@RequestParam String memId) {
        MemberUpdateDto memberInfo = memberService.getInfo(memId);
        if (memberInfo == null) {
            return ApiResponseDto.fail("사원 정보를 찾을 수 없습니다.");
        }

        Map<String, Object> data = new HashMap<>();
        data.put("user", memberInfo);
        data.put("annual", memberService.getAnnualInfo(memId));
        data.put("annualHistoryList", memberService.getAnnualLeaveHistory(memId));

        return ApiResponseDto.ok(data, "사원 정보 조회 성공");
    }

}