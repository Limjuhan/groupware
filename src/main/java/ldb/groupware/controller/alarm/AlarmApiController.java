package ldb.groupware.controller.alarm;

import ldb.groupware.dto.alarm.AlarmDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.service.alarm.AlarmService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

@Slf4j
@RestController
@RequestMapping("/alarm")
public class AlarmApiController {

    AlarmService alarmService;

    public AlarmApiController(AlarmService alarmService) {
        this.alarmService = alarmService;
    }

    @PostMapping("markAsRead")
    public ResponseEntity<ApiResponseDto<Void>> markAsRead(AlarmDto dto,
                                                           @SessionAttribute("loginId") String loginId) throws IllegalAccessException {
        alarmService.markAsRead(dto, loginId);
        return ApiResponseDto.successMessage("알람정보 업데이트 성공");
    }

}
