package ldb.groupware.controller.admin;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import ldb.groupware.dto.admin.MenuFormDto;
import ldb.groupware.dto.member.MemberFormDto;
import ldb.groupware.service.admin.AdminService;
import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Controller
@RequestMapping("/admin")
public class AdminController {
    private final MemberService memberService;
    private final AdminService adminService;

    public AdminController(MemberService memberService, AdminService adminService) {
        this.memberService = memberService;
        this.adminService = adminService;
    }

    @GetMapping("dashBoard")
    public String dashBoard() {
        return "admin/dashBoard";
    }

    @GetMapping("commTypeManage")
    public String CommTypeManage() {
        return "admin/commTypeManage";
    }

    // 사원 관리 페이지 
    @GetMapping("getMemberList")
    public String getMemberList(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        return "admin/memberList";
    }

    // 사원 등록 페이지
    @GetMapping("getMemberForm")
    public String getMemberForm(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        model.addAttribute("rankList", memberService.getRankList());
        model.addAttribute("memberFormDto", new MemberFormDto());
        return "admin/memberForm";
    }

    // 사원 등록
    @PostMapping("insertMemberByMng")
    public String insertMemberByMng(@Valid @ModelAttribute("memberFormDto") MemberFormDto dto,
                                    BindingResult bindingResult,
                                    Model model,
                                    @RequestParam(value = "photo", required = false) MultipartFile file,
                                    HttpSession session) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("deptList", memberService.getDeptList());
            model.addAttribute("rankList", memberService.getRankList());
            return "admin/memberForm";
        }

        String loginId = (String) session.getAttribute("loginId");
        boolean success = memberService.insertMember(dto, file,loginId);
        if (success) {
            return "redirect:/admin/getMemberList";
        } else {
            model.addAttribute("msg", "사원 등록 실패 하였습니다.");
            model.addAttribute("url", "/admin/getMemberForm");
            return "alert";
        }
    }

    // 부서별 권한설정
    @GetMapping("getDeptAuthList")
    public String getDeptAuthList(Model model) {
        model.addAttribute("deptList", memberService.getDeptList());
        return "admin/deptAuthList";
    }

    // 메뉴 등록 페이지
    @GetMapping("getMenuForm")
    public String getMenuForm(Model model) {
        model.addAttribute("dto", new MenuFormDto());
        return "admin/menuForm";
    }
    // 메뉴 등록
    @PostMapping("insertMenu")
    public String insertmenu(@Valid @ModelAttribute("dto") MenuFormDto dto,
                             BindingResult bresult,
                             HttpSession session,
                             Model model) {
        if(bresult.hasErrors()) {
            return "admin/menuForm";
        }
        String loginId = (String) session.getAttribute("loginId");
        boolean success = adminService.insertMenu(dto,loginId);

        if (success) {
           return "redirect:/admin/getDeptAuthList";
        }else{
            model.addAttribute("msg","메뉴 등록 실패 하였습니다.");
            model.addAttribute("url", "/admin/getMenuForm");
            return "alert";
        }
    }
}