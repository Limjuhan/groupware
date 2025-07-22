package ldb.groupware.controller.admin;

import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberFormDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final MemberService memberService;

    public AdminController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping("dashBoard")
    public String dashBoard() {
        return "admin/dashBoard";
    }

    @GetMapping("employeeDetail")
    public String employeeDetail() {
        return "admin/employeeDetail";
    }

    @GetMapping("itemListManage")
    public String itemListManage() {
        return "admin/itemListManage";
    }

    @GetMapping("itemRegistForm")
    public String itemRegistForm() {
        return "admin/itemRegistForm";
    }

    @GetMapping("meetingRoomManage")
    public String meetingRoomManage() {
        return "admin/meetingRoomManage";
    }

    @GetMapping("meetingRoomRegisterForm")
    public String meetingRoomRegisterForm() {
        return "admin/meetingRoomRegisterForm";
    }

    @GetMapping("memberInfoUpdate")
    public String memberInfoUpdate() {
        return "admin/memberInfoUpdate";
    }

    @GetMapping("faqWrite")
    public String faqWrite() {
        return "admin/faqWrite";
    }


    @GetMapping("vehicleManage")
    public String vehicleManage() {
        return "admin/vehicleManage";
    }

    @GetMapping("vehicleRegisterForm")
    public String vehicleRegisterForm() {
        return "admin/vehicleRegisterForm";
    }

    @GetMapping("registerUser")
    public String registerUser() {
        return "admin/registerUser";
    }

    @GetMapping("calendarWrite")
    public String calendarWrite() {
        return "admin/calendarWrite";
    }

    @GetMapping("calendarManage")
    public String calendarManage() {
        return "admin/calendarManage";
    }

    @GetMapping("faqManage")
    public String faqManage() {
        return "admin/faqManage";
    }

    @GetMapping("deptAuth")
    public String deptAuth() {
        return "admin/deptAuth";
    }

    @GetMapping("commTypeManage")
    public String CommTypeManage() {
        return "admin/commTypeManage";
    }

    @GetMapping("getMemberList")
    public String getMemberList(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/getMemberList";
    }

    @GetMapping("getMemberForm")
    public String getMemberForm(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/getMemberForm";
    }

    @PostMapping("insertMemberByMng")
    public String insertMemberByMng(@Valid @ModelAttribute MemberFormDto dto, BindingResult bresult, Model model) {
        if (bresult.hasErrors()) {
            model.addAttribute("deptList", memberService.getDeptList());
            model.addAttribute("rankList", memberService.getRankList());
            return "admin/getMemberForm";
        }

        boolean success = memberService.insertMember(dto);

        if (success) {
            model.addAttribute("url", "/admin/getMemberList");
        } else {
            model.addAttribute("msg", "사원 등록 실패");
            model.addAttribute("url", "/admin/getMemberForm");
        }

        return "alert";
    }
}
