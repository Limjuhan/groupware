package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.admin.DashboardInfoDto;
import ldb.groupware.dto.admin.MenuDto;
import ldb.groupware.dto.admin.UpdateAnnualDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberSearchDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.service.admin.AdminService;
import ldb.groupware.service.annualleave.AnnualService;
import ldb.groupware.service.common.CommonService;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminApiController {

    private final MemberService memberService;
    private final AdminService adminService;
    private final CommonService commonService;
    private final AnnualService annualService;

    public AdminApiController(MemberService memberService,
                              AdminService adminService,
                              CommonService commonService,
                              AnnualService annualService) {
        this.memberService = memberService;
        this.adminService = adminService;
        this.commonService = commonService;
        this.annualService = annualService;
    }

    /** 사원 목록 */
    @GetMapping("searchMembers")
    public Map<String, Object> searchMembers(@ModelAttribute MemberSearchDto searchDto) {
        return memberService.getMembers(searchDto);
    }

    /** 사원 설정(모달 - 직급,부서 설정) */
    @PostMapping("updateMemberByMng")
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(@RequestBody UpdateMemberDto dto,
                                                                             HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        return memberService.updateMemberByMng(dto, loginId);
    }

    /** 사원목록 (모달 - 사원정보) */
    @GetMapping("getMemberInfo")
    public ResponseEntity<ApiResponseDto<MemberInfoDto>> getMemberInfo(@RequestParam String memId) {
        MemberInfoDto info = memberService.getMemberInfo(memId);
        if (info == null) {
            return ApiResponseDto.fail("사원 정보를 찾을 수 없습니다.");
        }
        return ApiResponseDto.ok(info, "사원 정보 조회 성공");
    }

    /** 메뉴 목록 */
    @GetMapping("menuList")
    public List<MenuDto> getMenuList() {
        return adminService.getMenuList();
    }

    /** 부서 선택 시 권한 */
    @GetMapping("menuAuthority")
    public List<String> getMenuAuthority(@RequestParam String deptId) {
        return adminService.getMenuAuthority(deptId);
    }

    /** 부서별 권한 설정 */
    @PostMapping("updateAuth")
    public ResponseEntity<ApiResponseDto<Void>> updateAuth(
            @RequestParam String deptId,
            @RequestBody List<String> menuList) {
        adminService.updateAuth(deptId, menuList);
        return ApiResponseDto.successMessage("부서별 권한 설정 완료되었습니다.");
    }

    /** 대시보드 정보 로드 */
    @GetMapping("getAnnualLeaveUsage")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getAnnualLeaveUsage(
            @RequestParam("year") Integer year,
            @RequestParam(value = "deptId", required = false) String deptId,
            @RequestParam("page") int page) {
        Map<String, Object> result = adminService.getAnnualLeaveUsage(year, deptId, page);
        return ApiResponseDto.ok(result);
    }

    /** 부서목록 조회 */
    @GetMapping("getDeptList")
    public ResponseEntity<ApiResponseDto<List<DeptDto>>> getDeptList() {
        return ApiResponseDto.ok(commonService.getDeptList());
    }

    /** 엑셀 다운 */
    @GetMapping("annualLeaveExcel")
    public void downloadAnnualLeaveExcel(@RequestParam Integer year,
                                         @RequestParam(required = false) String deptId,
                                         HttpServletResponse response) throws IOException {

        List<DashboardInfoDto> list = adminService.getAnnualDataForExcel(year, deptId);

        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("연차 사용률 현황");

        // 스타일 설정
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontName("맑은 고딕");
        headerStyle.setFont(headerFont);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        CellStyle numberStyle = workbook.createCellStyle();
        numberStyle.cloneStyleFrom(dataStyle);
        numberStyle.setDataFormat(workbook.createDataFormat().getFormat("0"));

        // 헤더 생성
        String[] headers = {"부서", "이름", "직급", "총 연차", "사용 연차", "잔여 연차", "사용률"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // 데이터 생성
        int rowNum = 1;
        for (DashboardInfoDto dto : list) {
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(dto.getDeptName());
            row.createCell(1).setCellValue(dto.getMemName());
            row.createCell(2).setCellValue(dto.getRankName());
            row.createCell(3).setCellValue(dto.getTotalDays());
            row.createCell(4).setCellValue(dto.getUseDays());
            row.createCell(5).setCellValue(dto.getRemainDays());
            row.createCell(6).setCellValue(dto.getAnnualPercent());
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1012);
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String fileName = URLEncoder.encode("연차_사용률_" + year + ".xlsx", StandardCharsets.UTF_8);
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    /** 연차 수정 */
    @PostMapping("updateAnnualLeave")
    public ResponseEntity<ApiResponseDto<Void>> updateAnnualLeave(@RequestBody UpdateAnnualDto dto,
                                                                  @SessionAttribute("loginId") String loginId) {
        annualService.updateAnnualLeave(dto, loginId);
        return ApiResponseDto.successMessage("연차정보 수정 성공.");
    }
}
