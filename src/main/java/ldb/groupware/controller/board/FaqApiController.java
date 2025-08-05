package ldb.groupware.controller.board;

import ldb.groupware.service.board.FaqService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import java.util.Map;

@RestController
@RequestMapping("/api/faq")
public class FaqApiController {
    private final FaqService faqService;

    public FaqApiController(FaqService faqService) {
        this.faqService = faqService;
    }

    @GetMapping("faqList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getFaqList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "searchType", defaultValue = "") String searchType,
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {

        try {
            PaginationDto pDto = new PaginationDto();
            pDto.setPage(currentPage);
            pDto.setSearchType(searchType);
            pDto.setKeyword(keyword);

            Map<String, Object> map = faqService.findFaqList(pDto);

            // 성공적으로 데이터를 가져온 경우
            return ApiResponseDto.ok(map, "FAQ 목록을 성공적으로 불러왔습니다.");

        } catch (Exception e) {
            // 예외 발생 시 서버 오류 응답
            return ApiResponseDto.error("FAQ 목록을 불러오는 중 오류가 발생했습니다.");
        }
    }
}