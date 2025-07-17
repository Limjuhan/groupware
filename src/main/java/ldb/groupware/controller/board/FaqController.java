package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.service.board.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    @GetMapping("getFaqList")
    public String faqList(Model model, HttpServletRequest request) {
        List<FaqListDto> list = faqService.findFaqList(request);
        model.addAttribute("faq", list);
        return "board/getFaqList";
    }

    //관리자의 자주묻는질문 관리페이지
    @GetMapping("getFaqListManage")
    public String faqManage(){
        return "board/getFaqListManage";
    }

    @GetMapping("getFaqForm")
    public String getFaqForm(){
        return"board/getFaqForm";
    }




}
