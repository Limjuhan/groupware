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
        return "reservation/vehicleList";
    }
    
    @PostMapping("insertFacilityRent")
    public String insertFacility(FacilityRentDto dto , Model model){
        //service.insertFacility(dto)
        System.out.println("dto :: "+dto);
        System.out.println(dto.getEndLocalDate());
        System.out.println(dto.getStartLocalDate());
        model.addAttribute("url", "getVehicleList");
        return "alert";
    }
}
