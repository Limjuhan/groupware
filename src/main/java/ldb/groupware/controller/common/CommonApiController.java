package ldb.groupware.controller.common;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.common.CommonCodeDto;
import ldb.groupware.service.common.CommonService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("common")
public class CommonApiController {

    CommonService commonService;

    public CommonApiController(CommonService commonService) {
        this.commonService = commonService;
    }

    // 코드 그룹별 조회
    @GetMapping("/list")
    public ResponseEntity<ApiResponseDto<Map<String, Map<String, Object>>>> getCodeList() {
        Map<String, Map<String, Object>> groupedCodes = commonService.getGroupedCodes();
        return ApiResponseDto.ok(groupedCodes);
    }

    // 사용여부 업데이트
    @PostMapping("/update-usage")
    public ResponseEntity<ApiResponseDto<Void>> updateUsage(@RequestBody List<CommonCodeDto> codes) {
        commonService.updateCodeUsage(codes);
        return ApiResponseDto.successMessage("공통코드 사용여부 변경 완료");
    }
}
