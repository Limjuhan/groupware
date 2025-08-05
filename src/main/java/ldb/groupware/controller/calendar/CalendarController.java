package ldb.groupware.controller.calendar;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.calendar.ScheduleEditFormDto;
import ldb.groupware.dto.calendar.ScheduleFormDto;
import ldb.groupware.service.calendar.CalendarService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/calendar")
public class CalendarController {

    private final CalendarService calendarService;

    public CalendarController(CalendarService calendarService) {
        this.calendarService = calendarService;
    }
    
    // 캘린더
    @GetMapping("getCalendar")
    public String getCalendar() {
        return "calendar/calendar";
    }
    
    // 일정 등록
    @GetMapping("getCalendarForm")
    public String getCalendarForm(Model model) {
        model.addAttribute("dto", new ScheduleFormDto());
        return "calendar/calendarForm";
    }

    // 일정 목록 조회
    @GetMapping("getCalendarList")
    public String getCalendarList() {
        return "calendar/calendarList";
    }

    // 일정 등록
    @PostMapping("insertCalendarByMng")
    public String insertCalendarByMng(@Valid @ModelAttribute("dto") ScheduleFormDto dto,
                                      BindingResult bresult,
                                      HttpSession session,
                                      Model model) {
        if (bresult.hasErrors()) {
            return "calendar/calendarForm";
        }

        String loginId = (String) session.getAttribute("loginId");

        if (dto.getStartAt() != null && dto.getEndAt() != null && dto.getEndAt().isBefore(dto.getStartAt())) {
            model.addAttribute("dateError", "종료일은 시작일보다 빠를 수 없습니다.");
            return "calendar/calendarForm";
        }

        calendarService.insertCalendar(dto,loginId);
        return "redirect:/calendar/getCalendarList";
    }
    
    //일정 수정 폼
    @GetMapping("getCalendarEditForm")
    public String getCalendarEditForm(@RequestParam("scheduleId") Integer scheduleId, Model model) {
        ScheduleEditFormDto dto = calendarService.getScheduleForEdit(scheduleId);
        model.addAttribute("dto", dto);
        return "/calendar/calendarEditForm";
    }

    // 일정 수정
    @PostMapping("updateCalendarByMng")
    public String updateCalendarByMng(@Valid @ModelAttribute("dto") ScheduleEditFormDto dto,
                                      BindingResult bresult,
                                      HttpSession session,
                                      Model model) {
        if (bresult.hasErrors()) {
            return "/calendar/calendarEditForm";
        }

        if (dto.getStartAt() != null && dto.getEndAt() != null && dto.getEndAt().isBefore(dto.getStartAt())) {
            model.addAttribute("dateError", "종료일은 시작일보다 빠를 수 없습니다.");
            return "calendar/calendarEditForm";
        }

        String loginId = (String) session.getAttribute("loginId");

        if (calendarService.updateCalendar(dto,loginId)){
            model.addAttribute("msg","업데이트성공");
        }else{
            model.addAttribute("msg","업데이트실패");
        }

        return "redirect:/calendar/getCalendarList";
    }

}
