package ldb.groupware.controller.calendar;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/calendar")
public class CalendarController {

    @GetMapping("calendar")
    public String getCalendar() {
        return "calendar";
    }

    @GetMapping("calendarForm")
    public String getCalendarForm() {
        return "calendarForm";
    }

    @GetMapping("calendarList")
    public String getCalendarList() {
        return "calendarList";
    }
}
