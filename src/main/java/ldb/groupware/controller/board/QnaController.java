package ldb.groupware.controller.board;

import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.service.board.QnaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@RequestMapping("/board")
public class QnaController {

    private QnaService service;

    public QnaController(QnaService service){
        this.service = service;

    }

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

}
