package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.service.board.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    @GetMapping("getFaqList")
    public String faqList(Model model,   @RequestParam(value = "page", defaultValue = "1") int currentPage) {
        PaginationDto pageDto = new PaginationDto();
        pageDto.setPage(currentPage);

        Map<String, Object> map = faqService.findFaqList(pageDto);
        pageDto = (PaginationDto)map.get("pageDto");
        System.out.println("pageDto = " + pageDto);
        model.addAttribute("faq", map.get("list"));
        model.addAttribute("pageDto", pageDto);
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
