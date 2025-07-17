package ldb.groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @GetMapping("itemList")
    public String itemList() {
        return "reservation/itemList";
    }

    @GetMapping("itemRequestForm")
    public String itemRequestForm() {
        return "reservation/itemRequestForm";
    }
    @GetMapping("meetingRoomList")
    public String meetingRoomList() {
        return "reservation/meetingRoomList";
    }

    @GetMapping("meetingRoomReserve")
    public String meetingRoomReserve() {
        return "reservation/meetingRoomReserve";
    }
    @GetMapping("reservationList")
    public String reservationList() {
        return "reservation/reservationList";
    }
    @GetMapping("vehicleList")
    public String vehicleList() {
        return "reservation/vehicleList";
    }
}
