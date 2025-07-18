package ldb.groupware.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    
    @GetMapping("dashBoard")
    public String dashBoard(){
        return "admin/dashBoard";
    }
    
    @GetMapping("employeeDetail")
    public String employeeDetail(){
        return "admin/employeeDetail";
    }
    
    @GetMapping("itemListManage")
    public String itemListManage(){
        return "admin/itemListManage";
    }
    
    @GetMapping("itemRegistForm")
    public String itemRegistForm(){
        return "admin/itemRegistForm";
    }
    
    @GetMapping("meetingRoomManage")
    public String meetingRoomManage(){
        return "admin/meetingRoomManage";
    }

    @GetMapping("meetingRoomRegisterForm")
    public String meetingRoomRegisterForm(){
        return "admin/meetingRoomRegisterForm";
    }
    @GetMapping("memberInfoUpdate")
    public String memberInfoUpdate(){
        return "admin/memberInfoUpdate";
    }
    @GetMapping("faqWrite")
    public String faqWrite(){
        return "admin/faqWrite";
    }


    @GetMapping("vehicleManage")
    public String vehicleManage(){
        return "admin/vehicleManage";
    }

    @GetMapping("vehicleRegisterForm")
    public String vehicleRegisterForm(){
        return "admin/vehicleRegisterForm";
    }

    @GetMapping("registerUser")
    public String registerUser(){
        return "admin/registerUser";
    }
    @GetMapping("calendarWrite")
    public String calendarWrite(){
        return"admin/calendarWrite";
    }

    @GetMapping("calendarManage")
    public String calendarManage(){
        return"admin/calendarManage";
    }

    @GetMapping("faqManage")
    public String faqManage(){
        return "admin/faqManage";
    }

    @GetMapping("deptAuth")
    public String deptAuth(){
        return "admin/deptAuth";
    }

    @GetMapping("commTypeManage")
    public String CommTypeManage(){
        return "admin/commTypeManage";
    }
    

}
