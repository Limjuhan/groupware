package ldb.groupware.controller.facility;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import ldb.groupware.dto.facility.SearchDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.facility.FacilityService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@RequestMapping("facility/")
@Controller
public class FacilityController {

    private final FacilityService service;

    public  FacilityController(FacilityService service){
        this.service = service;
    }

    @GetMapping("getVehicleList")
    public String getVehicleList(Model model,PaginationDto pageDto, SearchDto searchDto){
        Map<String, Object> map = service.getFacilityList(pageDto,searchDto);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto",map.get("pageDto"));
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
    public String getMeetingRoomList(Model model, PaginationDto dto, SearchDto dto2){
        Map<String, Object> map = service.getFacilityList(dto,dto2);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto",map.get("pageDto"));
        return "facility/meetingRoomList";
    }

    @GetMapping("getItemList")
    public String getItemList(Model model , PaginationDto dto, SearchDto dto2){

        Map<String, Object> map = service.getFacilityList(dto,dto2);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto",map.get("pageDto"));
        return "facility/itemList";
    }

    @GetMapping("getReservationList")
    public String getReservationList(Model model,PaginationDto dto , SearchDto sDto,HttpServletRequest request){
        System.out.println("sdto :: "+sDto);
        Map<String,Object> map = service.getReserveList(dto,request);
        return "facility/reservationList";
    }





}
