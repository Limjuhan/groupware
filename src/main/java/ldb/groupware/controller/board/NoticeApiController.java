package ldb.groupware.controller.board;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.board.NoticeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/notice")
public class NoticeApiController {

    private final NoticeService service;

    public NoticeApiController(NoticeService service) {
        this.service = service;
    }

    @GetMapping("noticeList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getNoticeList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "searchType", defaultValue = "") String searchType,
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {
        try {
            PaginationDto pageDto = new PaginationDto();
            pageDto.setPage(currentPage);
            pageDto.setSearchType(searchType);
            pageDto.setKeyword(keyword);

            Map<String, Object> noticeData = service.getNoticeList(pageDto);

            return ApiResponseDto.ok(noticeData, "공지사항 목록을 성공적으로 불러왔습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("공지사항 목록을 불러오는 중 오류가 발생했습니다.");
        }
    }
}
