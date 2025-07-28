package ldb.groupware.controller.facility;

import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import ldb.groupware.service.facility.FacilityService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@RequestMapping("facility/")
@Controller
public class FacilityController {

    private final FacilityService service;

    public  FacilityController(FacilityService service){
        this.service = service;
    }

    @GetMapping("getVehicleList")
    public String getVehicleList(Model model){
        String type = "R_01";
        List<FacilityListDto> dto = service.getFacilityList(type);
        model.addAttribute("facility", dto);
        return "facility/vehicleList";
    }
    
    @PostMapping("insertFacilityRent")
    public String insertFacility(FacilityRentDto dto , Model model){
        if(service.insertFacility(dto)){
            model.addAttribute("msg", "예약성공");
            model.addAttribute("url", "getReservationList");
        }
        else{
            model.addAttribute("msg","예약실패");
            model.addAttribute("url", "getVehicleList");
        }
        return "alert";
    }
    @GetMapping("getMeetingRoomList")
    public String getMeetingRoomList(Model model){
        return "facility/meetingRoomList";
    }

    @GetMapping("getReservationList")
    public String getReservationList(Model model){
        return "facility/reservationList";
    }




}
