package ldb.groupware.controller.board;


import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.NoticeFormDto;
import ldb.groupware.dto.board.NoticeUpdateDto;
import ldb.groupware.dto.board.PaginationDto;
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
           PaginationDto paging, Model model  ) {
        paging.setPage(currentPage);
        Map<String,Object> map =service.getNoticeList(paging);
        model.addAttribute("notice",map.get("notice"));
        model.addAttribute("pageDto",map.get("pageDto"));
        model.addAttribute("pinnedList",map.get("pinnedList"));

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
        service.plusCnt(id);
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
                                    NoticeUpdateDto dto, Model model) {
        String[] existingFiles = dto.getExistingFiles();//삭제버튼을 누른 파일들
        if(existingFiles!=null && existingFiles.length>0) { //삭제를 아무것도안했을경우를 대비
            service.deleteFile(existingFiles);
        }
        if(service.updateNotice(files,dto)){
            model.addAttribute("msg","업뎃성공");
        }
        else{
            model.addAttribute("msg","업뎃 실패");
        }
        return "alert";
    }

    @GetMapping("deleteNoticeByMng")
    public String deleteNoticeByMng(Model model , @RequestParam("id")  String id ) {
        System.out.println(id);
        if(service.deleteNotice(id)){
            model.addAttribute("msg","삭제성공");
        }
        else{
            model.addAttribute("msg","삭제실패");
        }
        model.addAttribute("url","getNoticeList");
        return "alert";
    }

}
