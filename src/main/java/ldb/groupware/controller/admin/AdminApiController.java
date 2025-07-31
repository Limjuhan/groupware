package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.admin.DashboardInfoDto;
import ldb.groupware.dto.admin.MenuDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberSearchDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.service.admin.AdminService;
import ldb.groupware.service.common.CommonService;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminApiController {

    private final MemberService memberService;
    private final AdminService adminService;
    private final CommonService  commonService;

    public AdminApiController(MemberService memberService, AdminService adminService, CommonService commonService) {
        this.memberService = memberService;
        this.adminService = adminService;
        this.commonService = commonService;
    }

    // 사원 목록
    @GetMapping("searchMembers")
    public Map<String, Object> searchMembers(@ModelAttribute MemberSearchDto searchDto) {
        return memberService.getMembers(searchDto);
    }

    // 사원 설정(모달 - 직급,부서 설정)
    @PostMapping("updateMemberByMng")
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(@RequestBody UpdateMemberDto dto,
                                                                             HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        return memberService.updateMemberByMng(dto,loginId);
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

    // 메뉴 목록
    @GetMapping("menuList")
    public List<MenuDto> getMenuList() {
        return adminService.getMenuList();
    }

    // 부서 선택 시 권한
    @GetMapping("menuAuthority")
    public List<String> getMenuAuthority(@RequestParam String deptId) {
        return adminService.getMenuAuthority(deptId);
    }

    // 부서별 권한 설정
    @PostMapping("updateAuth")
    public ResponseEntity<ApiResponseDto<Void>> updateAuth(
            @RequestParam String deptId,
            @RequestBody List<String> menuList) {
        adminService.updateAuth(deptId, menuList);
        return ApiResponseDto.successMessage("부서별 권한 설정 완료되었습니다.");
    }

    // 대시보드 정보 로드
    @GetMapping("getAnnualLeaveUsage")
    public ResponseEntity<ApiResponseDto<List<DashboardInfoDto>>> getAnnualLeaveUsage(
            @RequestParam("year") String year,
            @RequestParam(value = "deptId", required = false) String deptId) {

        try {
            List<DashboardInfoDto> list = adminService.getAnnualLeaveUsage(year, deptId);
            log.info("연차정보확인:{}", list);
            return ApiResponseDto.ok(list);
        } catch (Exception e) {
            return ApiResponseDto.error("연차 사용정보 조회 실패");
        }
    }

    // 부서목록 조회
    @GetMapping("getDeptList")
    public ResponseEntity<ApiResponseDto<List<DeptDto>>> getDeptList() {
        List<DeptDto> deptList;

        try {
            deptList = commonService.getDeptList();
            return ApiResponseDto.ok(deptList);
        } catch (Exception e) {
            return ApiResponseDto.fail(e.getMessage());
        }
    }
}