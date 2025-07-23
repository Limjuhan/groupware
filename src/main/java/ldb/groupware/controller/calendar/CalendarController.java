package ldb.groupware.controller.calendar;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/calendar")
public class CalendarController {

    @GetMapping("calendar")
    public String getCalendar() {
        return "calendar/calendar";
    }

    @GetMapping("calendarForm")
    public String getCalendarForm() {
        return "calendar/calendarForm";
    }

    @GetMapping("calendarList")
    public String getCalendarList() {
        return "calendar/calendarList";
    }
}
