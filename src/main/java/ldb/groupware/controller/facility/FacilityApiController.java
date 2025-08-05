package ldb.groupware.controller.facility;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.facility.SearchDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.facility.FacilityService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/facility")
public class FacilityApiController {

    private final FacilityService service;

    public FacilityApiController(FacilityService service) {
        this.service = service;
    }

    // 공용 설비 목록 조회 (차량, 회의실, 비품)
    @GetMapping("list")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getFacilityList(
            PaginationDto pDto, SearchDto sDto,
            @RequestParam(value = "facType") String facType) {
        try {
            sDto.setFacType(facType);
            Map<String, Object> data = service.getFacilityList(pDto, sDto);
            return ApiResponseDto.ok(data, "공용 설비 목록을 성공적으로 불러왔습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("공용 설비 목록을 불러오는 중 오류가 발생했습니다.");
        }
    }

    // 내 예약 내역 조회
    @GetMapping("myReservation")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getMyReservationList(
            PaginationDto pDto, SearchDto sDto, HttpServletRequest request) {
        try {
            Map<String, Object> data = service.getReserveList(pDto, sDto, request);
            return ApiResponseDto.ok(data, "내 예약 내역을 성공적으로 불러왔습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("예약 내역을 불러오는 중 오류가 발생했습니다.");
        }
    }
}
