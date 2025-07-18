package ldb.groupware.controller.board;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.service.board.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class FaqController {


    private  FaqService faqService;

    public FaqController(FaqService faqService) {
        this.faqService = faqService;
    }

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

    //관리자의 자주묻는질문 관리페이지(권한 및 세션검증필요)
    @GetMapping("getFaqListManage")
    public String faqManage(Model model , @RequestParam(value = "page", defaultValue = "1") int currentPage){
        PaginationDto pageDto = new PaginationDto();
        pageDto.setPage(currentPage);

        Map<String, Object> map = faqService.findFaqList(pageDto);
        pageDto = (PaginationDto)map.get("pageDto");
        System.out.println("pageDto = " + pageDto);
        model.addAttribute("faq", map.get("list"));
        model.addAttribute("pageDto", pageDto);
        return "board/getFaqListManage";
    }

    //(권한 및 세션검증필요)
    @GetMapping("getFaqForm")
    public String getFaqForm(){
        return"board/getFaqForm";
    }

    //(권한 및 세션검증필요)
    @PostMapping("insertFaqByMng")
    public String insertFaqByMng(@Valid @ModelAttribute("faqFormDto")FaqFormDto dto , BindingResult bresult,Model model){
        if(bresult.hasErrors()){
            return  "board/getFaqForm";
        }
       if(faqService.insertFaq(dto)){
           model.addAttribute("msg","등록성공");
       }
       else{
           model.addAttribute("msg","등록실패");
       }
        return "alert";
    }




}
