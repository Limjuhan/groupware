package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.domain.QnaComment;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.board.CommentFormDto;
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

    @PostMapping("insertComment")
    public ResponseEntity<?> insertComment(@Valid @RequestBody CommentFormDto dto, BindingResult result , HttpSession session) {
        if(result.hasErrors()) {
            return  createValidationErrorResponse(result);
        }
       if(qnaService.insertComment(dto)){
           return ResponseEntity.ok(new ApiResponseDto<>(true,"성공",null));
       }
        return null;
    }

    @GetMapping("comments")
    public ResponseEntity<List<QnaComment>> getComments(@RequestParam("qnaId") int qnaId) {
        List<QnaComment> dto = qnaService.findCommentById(qnaId);// 댓글 리스트 조회

        System.out.println("dto :: "+dto);
        return ResponseEntity.ok(dto);
    }




}
