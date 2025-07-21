package ldb.groupware.controller.board;


import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.NoticeFormDto;
import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.board.NoticeUpdateDto;
import ldb.groupware.dto.common.PaginationDto;
import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.service.board.NoticeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class NoticeController {

    private NoticeService service;

    public NoticeController(NoticeService service) {
        this.service = service;
    }

    @GetMapping("getNoticeList")
    public String getNoticeList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage ,
            @RequestParam(value="searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword , Model model ) {
        System.out.println(searchType);
        System.out.println(keyword);
        PaginationDto paging = new PaginationDto();
        paging.setPage(currentPage);
        paging.setSearchType(searchType);
        paging.setKeyword(keyword);
        Map<String,Object> map =service.getNoticeList(paging);
        model.addAttribute("notice",map.get("notice"));
        model.addAttribute("pageDto",map.get("pageDto"));

        return "board/getNoticeList";
    }

    @GetMapping("getNoticeForm")
    public String getNoticeForm(Model model , HttpServletRequest request) {
        //String id = request.getSession().getAttribute("loginId");
        String id   = "admin";
       String name = service.getMember(id);
       model.addAttribute("memName",name);
       model.addAttribute("memId",id);
        return "board/getNoticeForm";
    }

    @PostMapping("insertNotice")
    public String insertNotice(@RequestParam("uploadFile") List<MultipartFile> files , NoticeFormDto dto, HttpServletRequest request){
        boolean result = service.insertNotice(dto,files,request);
        return "alert";
    }
    @GetMapping("getNoticeDetail")
    public String getNoticeDetail(Model model , @RequestParam("id")  String id) {
        Map<String,Object> map = service.getNoticeById(id);
        model.addAttribute("notice",map.get("notice"));
        model.addAttribute("attach",map.get("attach"));
        return "board/getNoticeDetail";
    }

    @GetMapping("getNoticeEditForm")
    public String getNoticeEditForm(Model model , @RequestParam("id")  String id) {
        Map<String, Object> noticeById = service.getNoticeById(id);
        model.addAttribute("notice",noticeById.get("notice"));
        model.addAttribute("attachedFiles",noticeById.get("attach"));
        return "board/getNoticeEditForm";
    }

    @PostMapping("updateNoticeByMng")
    public String updateNoticeByMng(@RequestParam("uploadFile") List<MultipartFile> files ,
                                    NoticeUpdateDto dto, Model model , HttpServletRequest request) {
        String[] existingFiles = dto.getExistingFiles(); //삭제한 파일들
        //아마 삭제한파일을 where절에넣어서 삭제 후
        // 새로추가한걸 notice_id이용해서 insert문으로 따로넣을듯?
        int s = dto.getNoticeId();
        String businessId = String.valueOf(s);
        //service.deleteFile(existingFiles,businessId); //삭제버튼을 누른 파일들 삭제

        return "alert";
    }

}
