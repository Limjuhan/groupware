package ldb.groupware.dto.apiresponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponseDto<T> {

    private boolean success;   // 성공 여부
    private String message;    // 응답 메시지
    private T data;            // 응답 데이터 (null 허용)

    // 성공 응답 (메시지 기본값: "성공")
    public static <T> ResponseEntity<ApiResponseDto<T>> ok(T data) {
        return ok(data, "성공");
    }

    // 성공 응답 (메시지 커스터마이징)
    public static <T> ResponseEntity<ApiResponseDto<T>> ok(T data, String message) {
        return ResponseEntity.ok(new ApiResponseDto<>(true, message, data));
    }

    //  단순 성공 (데이터 없음, 메시지 커스터마이징)
    public static <T> ResponseEntity<ApiResponseDto<T>> successMessage(String message) {
        return ResponseEntity.ok(new ApiResponseDto<>(true, message, null));
    }

    //  실패 응답 (200 OK 상태이지만 처리 실패)
    public static <T> ResponseEntity<ApiResponseDto<T>> fail(String message) {
        return ResponseEntity.ok(new ApiResponseDto<>(false, message, null));
    }

    //  서버 오류 (500 상태)
    public static <T> ResponseEntity<ApiResponseDto<T>> error(String message) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ApiResponseDto<>(false, message, null));
    }

    // 상태코드 직접 지정
    public static <T> ResponseEntity<ApiResponseDto<T>> status(HttpStatus status, boolean success, String message, T data) {
        return ResponseEntity.status(status).body(new ApiResponseDto<>(success, message, data));
    }
}
