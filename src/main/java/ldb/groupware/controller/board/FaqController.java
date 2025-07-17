package ldb.groupware.controller.board;

import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.service.board.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    @GetMapping("getFaqList")
    public String faqList(){
        List<FaqListDto> list = faqService.findFaqList();
        System.out.println("controller List"+list);
        return "board/getFaqList";
    }


}
