package ldb.groupware.controller;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.facility.MyFacilityReserveDto;
import ldb.groupware.service.board.NoticeService;
import ldb.groupware.service.calendar.CalendarService;
import ldb.groupware.service.facility.FacilityService;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    private final CalendarService calendarService;
    private final NoticeService noticeService;
    private final FacilityService facilityService;

    public HomeController(CalendarService calendarService, NoticeService noticeService, FacilityService facilityService) {
        this.calendarService = calendarService;
        this.noticeService = noticeService;
        this.facilityService = facilityService;
    }

    @GetMapping("/")
    public String home(Model model, HttpServletRequest request) {
        String loginId = (String)request.getSession().getAttribute("loginId");
        List<ScheduleListDto> scheduleList = calendarService.getRecentSchedules();
        List<NoticeListDto> noticeList = noticeService.getLatestNotices();
        List<MyFacilityReserveDto> myReservations = facilityService.getLatestReservations(loginId);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("myReservations", myReservations);
        model.addAttribute("scheduleList", scheduleList);
        return "home"; // → /WEB-INF/views/home.jsp 렌더링됨
    }

    @GetMapping("/error-test")
    public String errorTest() {
        throw new RuntimeException("테스트용 예외 발생!");
    }

}
