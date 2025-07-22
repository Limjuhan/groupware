package ldb.groupware.controller.admin;

import jakarta.validation.Valid;
import ldb.groupware.dto.member.MemberFormDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

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

    @GetMapping("vehicleManage")
    public String vehicleManage() {
        return "admin/vehicleManage";
    }

    @GetMapping("vehicleRegisterForm")
    public String vehicleRegisterForm() {
        return "admin/vehicleRegisterForm";
    }

    @GetMapping("calendarWrite")
    public String calendarWrite() {
        return "admin/calendarWrite";
    }




    @GetMapping("deptAuth")
    public String deptAuth() {
        return "admin/deptAuth";
    }

    @GetMapping("commTypeManage")
    public String CommTypeManage() {
        return "admin/commTypeManage";
    }

    @GetMapping("memberList")
    public String getMemberList(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/memberList";
    }

    @GetMapping("memberForm")
    public String getMemberForm(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/memberForm";
    }

    @PostMapping("insertMemberByMng")
    public String insertMemberByMng(@Valid @ModelAttribute MemberFormDto dto,
                                    BindingResult bresult,
                                    @RequestParam("uploadFile") List<MultipartFile> files,
                                    Model model) {
        System.out.println("photo"+files);
        if (bresult.hasErrors()) {
            model.addAttribute("deptList", memberService.getDeptList());
            model.addAttribute("rankList", memberService.getRankList());
            return "admin/memberForm";
        }

        boolean success = memberService.insertMember(dto,files);

        if (success) {
            model.addAttribute("url", "/admin/getMemberList");
        } else {
            model.addAttribute("msg", "사원 등록 실패");
            model.addAttribute("url", "/admin/getMemberForm");
        }

        return "alert";
    }
}
