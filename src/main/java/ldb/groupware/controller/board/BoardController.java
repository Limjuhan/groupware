package ldb.groupware.controller.board;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {

    @GetMapping("faqList")
    public String faqList(){
        return "getFaqList";
    }

    @GetMapping("noticeDetail")
    public String noticeDetail(){
        return "board/noticeDetail";
    }
    @GetMapping("noticeEdit")
    public String noticeEdit(){
        return "board/noticeEdit";
    }
    @GetMapping("noticeList")
    public String noticeList(){
        return "getNoticeList";
    }
    @GetMapping("noticeWrite")
    public String noticeWrite(){
        return "getNoticeForm";
    }

    @GetMapping("questionDetail")
    public String questionDetail(){
        return "board/questionDetail";
    }
    @GetMapping("questionList")
    public String questionList(){
        return "board/questionList";
    }
    @GetMapping("questionWrite")
    public String questionWrite(){
        return "board/questionWrite";
    }

}
