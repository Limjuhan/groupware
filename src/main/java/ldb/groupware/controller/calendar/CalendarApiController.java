package ldb.groupware.controller.calendar;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.calendar.EventDto;
import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.calendar.CalendarService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/calendar")
public class CalendarApiController {

    private final CalendarService calendarService;

    public CalendarApiController(CalendarService calendarService) {
        this.calendarService = calendarService;
    }

    @GetMapping("CalendarList")
    public ResponseEntity<ApiResponseDto<Map<String, Object>>> getCalendarList(
            @RequestParam(defaultValue = "1") int page) {

        PaginationDto pageDto = new PaginationDto();
        int totalCount = calendarService.getTotalCount();
        pageDto.setPageData(page, null, null, totalCount);
        pageDto.calculatePagination();

        List<ScheduleListDto> scheduleList = calendarService.getScheduleList(pageDto);

        Map<String, Object> data = new HashMap<>();
        data.put("scheduleList", scheduleList);
        data.put("pageDto", pageDto);

        return ApiResponseDto.ok(data);
    }

    @PostMapping("deleteCalendarByMng")
    public ResponseEntity<ApiResponseDto<Void>> deleteCalendarByMng(@RequestParam("scheduleId") Integer scheduleId) {
        int result = calendarService.deleteCalender(scheduleId);
        if (result <= 0) {
            return ApiResponseDto.fail("일정 삭제에 실패하였습니다.");
        } else {
            return ApiResponseDto.ok(null, "일정 삭제 되었습니다.");
        }
    }

    @GetMapping("getScheduleList")
    @ResponseBody
    public List<EventDto> getScheduleList() {
        return calendarService.getEventList();
    }

}
