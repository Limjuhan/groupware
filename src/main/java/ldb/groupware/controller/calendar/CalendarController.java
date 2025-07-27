package ldb.groupware.controller.calendar;

import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.calendar.CalendarService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/calendar")
public class CalendarController {

    private final CalendarService calendarService;

    public CalendarController(CalendarService calendarService) {
        this.calendarService = calendarService;
    }

    @GetMapping("getCalendar")
    public String getCalendar() {
        return "calendar/calendar";
    }

    @GetMapping("getCalendarForm")
    public String getCalendarForm() {
        return "calendar/calendarForm";
    }

    @GetMapping("getCalendarList")
    public String getCalendarList(@RequestParam(defaultValue = "1") int page, Model model) {

        PaginationDto pageDto = new PaginationDto();
        int totalCount = calendarService.getTotalCount();
        pageDto.setPageData(page, null, null, totalCount);
        pageDto.calculatePagination();

        List<ScheduleListDto> scheduleList = calendarService.getScheduleList(pageDto);

        model.addAttribute("scheduleList", scheduleList);
        model.addAttribute("pageDto", pageDto);

        return "calendar/calendarList";
    }
}
