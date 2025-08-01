package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.admin.DashboardInfoDto;
import ldb.groupware.dto.admin.MenuDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.member.MemberSearchDto;
import ldb.groupware.dto.member.UpdateMemberDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.admin.AdminService;
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
import java.util.HashMap;
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
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getAnnualLeaveUsage(
            @RequestParam("year") Integer year,
            @RequestParam(value = "deptId", required = false) String deptId,
            @RequestParam("page") int page) {

        try {
            Map<String, Object> result = adminService.getAnnualLeaveUsage(year, deptId, page);
            return ApiResponseDto.ok(result);
        } catch (Exception e) {
            return ApiResponseDto.fail("연차 사용정보 조회 실패." +  e.getMessage());
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

    // 엑셀 다운
    @GetMapping("annualLeaveExcel")
    public void downloadAnnualLeaveExcel(@RequestParam Integer year,
                                         @RequestParam(required = false) String deptId,
                                         HttpServletResponse response) throws IOException {

        // 1. 서비스에서 데이터 조회
        List<DashboardInfoDto> list = adminService.getAnnualDataForExcel(year, deptId);

        // 2. 엑셀 생성
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("연차 사용률 현황");

        // ================================
        // 3. 스타일 생성
        // ================================
        // (1) 헤더 스타일
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        XSSFFont headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontName("맑은 고딕"); // 기본 글꼴 강제
        headerStyle.setFont(headerFont);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        // (2) 데이터 셀 스타일
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        // (3) 숫자 셀 스타일 (소수점 없이)
        CellStyle numberStyle = workbook.createCellStyle();
        numberStyle.cloneStyleFrom(dataStyle);
        numberStyle.setDataFormat(workbook.createDataFormat().getFormat("0"));

        // (4) 퍼센트 셀 스타일 (소수점 1자리 %)
        CellStyle percentStyle = workbook.createCellStyle();
        percentStyle.cloneStyleFrom(dataStyle);
        percentStyle.setDataFormat(workbook.createDataFormat().getFormat("0.0%"));

        // ================================
        // 4. 헤더 행 생성
        // ================================
        String[] headers = {"부서", "이름", "직급", "총 연차", "사용 연차", "잔여 연차", "사용률"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // ================================
        // 5. 데이터 행 생성
        // ================================
        int rowNum = 1;
        for (DashboardInfoDto dto : list) {
            Row row = sheet.createRow(rowNum++);

            // 문자열 데이터
            Cell deptCell = row.createCell(0);
            deptCell.setCellValue(dto.getDeptName());
            deptCell.setCellStyle(dataStyle);

            Cell nameCell = row.createCell(1);
            nameCell.setCellValue(dto.getMemName());
            nameCell.setCellStyle(dataStyle);

            Cell rankCell = row.createCell(2);
            rankCell.setCellValue(dto.getRankName());
            rankCell.setCellStyle(dataStyle);

            // 숫자 데이터
            Cell totalCell = row.createCell(3);
            totalCell.setCellValue(dto.getTotalDays());
            totalCell.setCellStyle(numberStyle);

            Cell useCell = row.createCell(4);
            useCell.setCellValue(dto.getUseDays());
            useCell.setCellStyle(numberStyle);

            Cell remainCell = row.createCell(5);
            remainCell.setCellValue(dto.getRemainDays());
            remainCell.setCellStyle(numberStyle);

            // 사용률 (예: 0.75 → 75%)
            Cell percentCell = row.createCell(6);
            percentCell.setCellValue(dto.getAnnualPercent()); // 0.0 ~ 1.0 값이어야 % 포맷 적용됨

        }

        // ================================
        // 6. 컬럼 너비 자동 조정 + 여유
        // ================================
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1012); // 여유 폭
        }

        // ================================
        // 7. 응답 헤더 설정 → 다운로드 트리거
        // ================================
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String fileName = URLEncoder.encode("연차_사용률_" + year + ".xlsx", StandardCharsets.UTF_8);
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

        // ================================
        // 8. 파일 전송
        // ================================
        workbook.write(response.getOutputStream());
        workbook.close();
    }


}
























