package ldb.groupware.controller;

import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.service.calendar.CalendarService;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    private final CalendarService calendarService;
    public HomeController(CalendarService calendarService) {
        this.calendarService = calendarService;
    }

    @GetMapping("/")
    public String home(Model model) {
        List<ScheduleListDto> scheduleList = calendarService.getRecentSchedules();
        model.addAttribute("scheduleList", scheduleList);
        return "home"; // → /WEB-INF/views/home.jsp 렌더링됨
    }

    @GetMapping("/error-test")
    public String errorTest() {
        throw new RuntimeException("테스트용 예외 발생!");
    }

}
