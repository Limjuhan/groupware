package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.board.QnaFormDto;
import ldb.groupware.service.board.QnaService;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
                                   PaginationDto paging,Model model) {
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
    public String insertQna(@Valid QnaFormDto dto , BindingResult bindingResult, Model model ) {
        //(String)request.getSession("loginUser");
        String memName = memService.findNameById("LDB20220001");
        if(bindingResult.hasErrors()){
            model.addAttribute("memName", memName);
            model.addAttribute("loginUser", "LDB20220001");
            return "board/qnaForm";
        }
        System.out.println("dto"+dto);
        if(service.insertQna(dto)){
            model.addAttribute("msg", "등록성공");
        }
        else{
            model.addAttribute("msg", "등록실패");
        }
        return "alert";
    }

}
