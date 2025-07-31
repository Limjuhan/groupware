package ldb.groupware.controller.board;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import ldb.groupware.domain.MenuAuthority;
import ldb.groupware.dto.board.NoticeFormDto;
import ldb.groupware.dto.board.NoticeUpdateDto;
import ldb.groupware.dto.member.AuthDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.menu.MenuAuthorityMapper;
import ldb.groupware.service.admin.AdminService;
import ldb.groupware.service.board.NoticeService;
import ldb.groupware.service.member.MemberService;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class NoticeController {

    private final NoticeService service;
    private final AdminService adminService;
    private final MemberService memberService;

    public NoticeController(NoticeService service, AdminService adminService, MemberService memberService) {
        this.service = service;
        this.adminService = adminService;
        this.memberService = memberService;
    }

    //A_0002 (공지사항페이지 ) (권한처리X)
    @GetMapping("getNoticeList")
    public String getNoticeList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            PaginationDto paging, Model model) {
        paging.setPage(currentPage);
        Map<String, Object> map = service.getNoticeList(paging);
        model.addAttribute("notice", map.get("notice"));
        model.addAttribute("pageDto", map.get("pageDto"));
        model.addAttribute("pinnedList", map.get("pinnedList"));

        return "board/noticeList";
    }

    //공지사항등록(관리) (A_0003) (세션검증 필요)
    @GetMapping("getNoticeForm")
    public String getNoticeForm(Model model, HttpServletRequest request) {

        String id = (String) request.getSession().getAttribute("loginId");
        String redirect = validateUserAuth(id, model);
        if (redirect != null) {
            return redirect; // 권한 없으면 즉시 리턴
        }
        String name = service.getMember(id);
        model.addAttribute("memName", name);
        model.addAttribute("memId", id);
        return "board/noticeForm";
    }

    //공지사항등록->등록버튼 (A_003) (이것도역시 세션검증이필요)
    @PostMapping("insertNotice")
    public String insertNotice(@Valid @ModelAttribute("noticeFormDto") NoticeFormDto dto,
                               BindingResult result,
                               @RequestParam("uploadFile") List<MultipartFile> files,
                               HttpServletRequest request,
                               Model model) {
        String id = (String) request.getSession().getAttribute("loginId");
        String redirect = validateUserAuth(id, model);
        if (redirect != null) {
            return redirect; // 권한 없으면 즉시 리턴
        }
        String name = service.getMember(id);
        model.addAttribute("memName", name);
        model.addAttribute("memId", id);
        if (result.hasErrors()) {
            return "board/noticeForm";
        }
        String text = Jsoup.parse(dto.getNoticeContent()).text(); //summnerNote떄문에 순수문자열만으로 유효성검사
        System.out.println("HTML태그를  제거한 순수한 문자열 : " + text);
        if (text.trim().length() < 8) {
            result.rejectValue("noticeContent", "error.content.size");
            return "board/noticeForm";
        }

        //유효성검사 모두성공시
        if (service.insertNotice(dto, files)) {
            model.addAttribute("msg", "등록 성공");
        } else {
            model.addAttribute("msg", "등록 실패");
        }
        return "alert";
    }


    //공지사항상세보기 (A_002)(모두의권한)
    //수정삭제를 권한에따라 막아야하는데 그걸안했음
    //session으로 부서뽑고 권한뽑아서 처리해야할듯
    @GetMapping("getNoticeDetail")
    public String getNoticeDetail(Model model, @RequestParam("id") String id) {
        Map<String, Object> map = service.getNoticeById(id);
        model.addAttribute("notice", map.get("notice"));
        model.addAttribute("attach", map.get("attach"));
        service.plusCnt(id);
        return "board/noticeDetail";
    }

    //공지사항수정(A_0003) (권한이있어야가능)
    @GetMapping("getNoticeEditForm")
    public String getNoticeEditForm(Model model,
                                    @RequestParam("id") String id,
                                    HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        String redirect = validateUserAuth(loginId, model);
        if (redirect != null) {
            return redirect; // 권한 없으면 즉시 리턴
        }
        Map<String, Object> noticeById = service.getNoticeById(id);
        model.addAttribute("notice", noticeById.get("notice"));
        model.addAttribute("attachedFiles", noticeById.get("attach"));
        return "board/noticeEditForm";
    }

    //공지사항수정->수정버튼 (A_0003) (역시권한이 있어야함)
    @PostMapping("updateNoticeByMng")
    public String updateNoticeByMng(@Valid @ModelAttribute("noticeUpdateDto") NoticeUpdateDto dto,
                                    BindingResult result,
                                    @RequestParam("uploadFile") List<MultipartFile> files,
                                    Model model,
                                    @SessionAttribute("loginId") String loginId) {

        String redirect = validateUserAuth(loginId, model);
        if (redirect != null) {
            return redirect; // 권한 없으면 즉시 리턴
        }
        int length = dto.getNoticeContent().length();
        System.out.println("getNoticeContent" + length);
        if (result.hasErrors()) {
            String id = String.valueOf(dto.getNoticeId());
            Map<String, Object> noticeById = service.getNoticeById(id);
            model.addAttribute("notice", noticeById.get("notice"));
            model.addAttribute("attachedFiles", noticeById.get("attach"));
            return "board/noticeEditForm";
        }
        //summerNote는 태그값으로 들어오기때문에 문자열파싱해줌
        String text = Jsoup.parse(dto.getNoticeContent()).text();
        System.out.println("HTML을 제거한 순수한 문자열 : " + text);
        if (text.trim().length() < 8) {
            String id = String.valueOf(dto.getNoticeId());
            Map<String, Object> noticeById = service.getNoticeById(id);
            model.addAttribute("notice", noticeById.get("notice"));
            model.addAttribute("attachedFiles", noticeById.get("attach"));
            result.rejectValue("noticeContent", "error.content.size");
            return "board/noticeEditForm";

        }
        if (service.updateNotice(files, dto)) {
            model.addAttribute("msg", "업뎃성공");
        } else {
            model.addAttribute("msg", "업뎃 실패");
        }
        return "alert";
    }

    //공지사항 삭제(A_0003) 권한필요
    @GetMapping("deleteNoticeByMng")
    public String deleteNoticeByMng(Model model,
                                    @RequestParam("id") String id,
                                    @SessionAttribute("loginId") String loginId) {

        String redirect = validateUserAuth(loginId, model);
        if (redirect != null) {
            return redirect; // 권한 없으면 즉시 리턴
        }
        System.out.println(id);
        if (service.deleteNotice(id)) {
            model.addAttribute("msg", "삭제성공");
        } else {
            model.addAttribute("msg", "삭제실패");
        }
        model.addAttribute("url", "getNoticeList");
        return "alert";
    }

    private String validateUserAuth(String id,
                                    Model model) {
        AuthDto authDto = memberService.selectAuth(id);
        List<String> menuAuthority = adminService.getMenuAuthority(authDto.getDeptId());
        boolean hasAuth = false;

        for (String menuId : menuAuthority) {
            if ("A_0003".equals(menuId)) {
                hasAuth = true;
                break;
            }
        }
        if (!hasAuth) {
            model.addAttribute("msg", "[경고]공지사항관리 권한이 없습니다.");
            model.addAttribute("url", "/board/getNoticeList");
            return "alert";
        }
        return null;
    }


}
