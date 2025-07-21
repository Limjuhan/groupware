package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.common.ApiResponseDto;
import ldb.groupware.dto.common.PaginationDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminMemberApiController {

    private final MemberService memberService;

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
}
