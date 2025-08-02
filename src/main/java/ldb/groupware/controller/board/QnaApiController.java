package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.domain.QnaComment;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.board.CommentFormDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.board.QnaService;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/qna")
public class QnaApiController {

    private final QnaService qnaService;


    public QnaApiController(QnaService qnaService) {
        this.qnaService = qnaService;
    }

    private ResponseEntity<ApiResponseDto<Object>> createValidationErrorResponse(BindingResult bindingResult) {
        Map<String, String> errors = new HashMap<>();
        for (FieldError error : bindingResult.getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        return ResponseEntity.badRequest().body(new ApiResponseDto<>(false, "입력 값을 확인해주세요.", errors));
    }

    // 1. Q&A 목록 및 FAQ 목록 조회 API
    @GetMapping("qnaList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getQnaList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "searchType", defaultValue = "") String searchType,
            @RequestParam(value = "keyword", defaultValue = "") String keyword) {
        try {
            PaginationDto paging = new PaginationDto();
            paging.setPage(currentPage);
            paging.setSearchType(searchType);
            paging.setKeyword(keyword);

            Map<String, Object> qnaData = qnaService.getQnaList(paging);

            return ApiResponseDto.ok(qnaData, "질문 게시판 목록을 성공적으로 불러왔습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("질문 게시판 목록을 불러오는 중 오류가 발생했습니다.");
        }
    }

    // 2. Q&A 상세 정보 조회 API
    @GetMapping("qnaDetail/{qnaId}")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getQnaDetail(@PathVariable("qnaId") int qnaId) {
        try {
            Map<String, Object> detailData = qnaService.findDetailById(qnaId);
            return ApiResponseDto.ok(detailData, "Q&A 상세 정보를 성공적으로 불러왔습니다.");
        } catch (Exception e) {
            return ApiResponseDto.error("Q&A 상세 정보를 불러오는 중 오류가 발생했습니다.");
        }
    }


    //권한은필요없
    @PostMapping("insertComment")
    public ResponseEntity<?> insertComment(@Valid @RequestBody CommentFormDto dto, BindingResult result, HttpSession session) {
        if (result.hasErrors()) {
            return createValidationErrorResponse(result);
        }
        if (qnaService.insertComment(dto)) {
            return ResponseEntity.ok(new ApiResponseDto<>(true, "성공", null));
        }
        return null;
    }

    @GetMapping("comments")
    public ResponseEntity<List<QnaComment>> getComments(@RequestParam("qnaId") int qnaId) {
        List<QnaComment> dto = qnaService.findCommentById(qnaId);// 댓글 리스트 조회

        System.out.println("dto :: " + dto);
        return ResponseEntity.ok(dto);
    }


}
