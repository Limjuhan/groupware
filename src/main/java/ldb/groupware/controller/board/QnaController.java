package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import ldb.groupware.dto.board.*;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.board.QnaService;
import ldb.groupware.service.member.MemberService;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class QnaController {

    private final  QnaService service;
    private final MemberService memService;


    public QnaController(QnaService service,MemberService memService){
        this.service = service;
        this.memService = memService;

    }

    //질문게시판 목록 (자주묻는질문까지불러와야함)
    @GetMapping("getQnaList")
    public String getQnaList (@RequestParam(value = "page", defaultValue = "1") int currentPage ,
                              PaginationDto paging, Model model) {
        paging.setPage(currentPage); //현재페이지설정
        System.out.println("컨트롤러");
        Map<String,Object> map =service.getQnaList(paging);
        //faq , pageDto , qna생성
        model.addAttribute("pageDto", map.get("pageDto"));
        model.addAttribute("qna", map.get("qna"));
        model.addAttribute("faq", map.get("faq"));
        return "board/qnaList";
    }


    //질문작성폼
    @GetMapping("getQnaForm")
    public String getQnaForm(Model model , HttpServletRequest request) {
        //(String)request.getSession("loginUser");
        String loginUser = "LDB20220001";
        String memName = memService.findNameById(loginUser);//나중에 세션으로바꿔야함
        model.addAttribute("memName", memName);
        model.addAttribute("loginUser", loginUser);
        return  "board/qnaForm";
    }

    //작성 폼( 나중에는 세션id로 name뽑고할거임)
    @PostMapping("insertQna")
    public String insertQna(@Valid QnaFormDto dto , BindingResult bindingResult, Model model ,@RequestParam("uploadFile") List<MultipartFile> files ) {

        String memName = memService.findNameById(dto.getMemId());
        model.addAttribute("memName", memName);
        model.addAttribute("loginUser", dto.getMemId());
        if(bindingResult.hasErrors()){
            return "board/qnaForm";
        }
        String text = Jsoup.parse(dto.getQnaContent()).text();
        System.out.println("HTML태그를  제거한 순수한 문자열 : "+text);
        if(text.trim().length()<8){
            bindingResult.rejectValue("qnaContent", "error.content.size");
            return "board/qnaForm";
        }
        //유효성검사 성공 시
        System.out.println("dto"+dto);
        if(service.insertQna(dto,files)){
            model.addAttribute("msg", "등록성공");
        }
        else{
            model.addAttribute("msg", "등록실패");
        }
        return "alert";
    }

    @GetMapping("getQnaDetail")
    public  String getQnaDetail(Model model , HttpServletRequest request , @RequestParam("id")int  id) {
        System.out.println("getQuestionDetail컨트롤러 접근");
        String loginId = "admin";
        // loginId = (String)request.getSession().getAttribute("loginId");

       Map<String,Object> map = service.findDetailById(id);
        model.addAttribute("loginId", loginId);
        model.addAttribute("q",map.get("qna"));
        model.addAttribute("attach",map.get("attachments"));
        return  "board/qnaDetail";
    }

    @GetMapping("getQnaEditForm")
    public  String getQnaUpdate( @RequestParam("id")int  id , Model model , HttpServletRequest request) {
        String loginId = "admin";
        // loginId = (String)request.getSession().getAttribute("loginId");
        Map<String, Object> map = service.findDetailById(id);
        model.addAttribute("loginId", loginId);
        model.addAttribute("q",map.get("qna"));
        model.addAttribute("attachedFiles",map.get("attachments"));
        return "board/qnaEditForm";
    }

    @PostMapping("updateQna")
    public String updateQna(@Valid QnaUpdateDto dto ,BindingResult result, Model model ,@RequestParam("uploadFile") List<MultipartFile> files){
        String loginId = "admin";
        // loginId = (String)request.getSession().getAttribute("loginId");
        Map<String, Object> map = service.findDetailById(dto.getQnaId());
        model.addAttribute("loginId", loginId);
        model.addAttribute("q",map.get("qna"));
        model.addAttribute("attachedFiles",map.get("attachments"));
        if(result.hasErrors()){
            return "board/qnaEditForm";
        }
        String text = Jsoup.parse(dto.getQnaContent()).text();
        System.out.println("HTML태그를  제거한 순수한 문자열 : "+text);
        if(text.trim().length()<8){
            result.rejectValue("qnaContent", "error.content.size");
            return "board/qnaEditForm";
        }

        //유효성검사 성공시
        if(service.updateQna(dto,files)){
            model.addAttribute("msg","수정성공");
        }
        else{
            model.addAttribute("msg","수정실패");
        }

        return "alert";
    }

    @GetMapping("deleteQnaByMng")
    public String deleteQnaByMng(Model model , @RequestParam("id")  int id ) {
        System.out.println(id);
        if(service.deleteById(id)){
            model.addAttribute("msg","삭제성공");
        }
        else{
            model.addAttribute("msg","삭제실패");
        }
        model.addAttribute("url","getQnaList");
        return "alert";
    }

    @GetMapping("deleteCommentByMng")
    public String deleteCommentByMng(Model model , @RequestParam("id")  int id , @RequestParam("qnaId")int qnaId) {
        System.out.println("qnaID :::::: "+qnaId);
        if(service.deleteCommentById(id)){
            model.addAttribute("msg","삭제성공");
        }
        else{
            model.addAttribute("msg","삭제실패");
        }
        model.addAttribute("url","getQnaDetail?id="+qnaId);
        return "alert";
    }



}
