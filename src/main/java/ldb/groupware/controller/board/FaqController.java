package ldb.groupware.controller.board;

import jakarta.validation.Valid;
import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.board.FaqService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class FaqController {

    private  final FaqService faqService;

    public FaqController(FaqService faqService) {
        this.faqService = faqService;
    }

    //자주묻는질문 페이지(A_0004)
    @GetMapping("getFaqList")
    public String faqList() {
        return "board/faqList";
    }

    //관리자의 자주묻는질문 관리페이지(권한 및 세션검증필요) (A_0006)
    //여기는 관리자만 들어와야함 (경영지원팀도 X)
    @GetMapping("getFaqListManage")
    public String faqManage(Model model , @RequestParam(value = "page", defaultValue = "1") int currentPage,PaginationDto pDto){
        pDto.setPage(currentPage);
        Map<String, Object> map = faqService.findFaqList(pDto);
        pDto = (PaginationDto)map.get("pageDto");
        System.out.println("pageDto = " + pDto);
        model.addAttribute("faq", map.get("list"));
        model.addAttribute("pageDto", pDto);
        return "board/faqListManage";
    }

    //(자주묻는질문관리 -> 등록페이지)(A_0006) (오직 관리자만접근해야함 session정보(mem_id)가들어가지않음)
    @GetMapping("getFaqForm")
    public String getFaqForm(Model model){
        List<DeptDto> dept = faqService.findDept();
        model.addAttribute("dept", dept);
        return"board/faqForm";
    }

    //(자주묻는질문관리 -> 등록버튼)(A_0006)(오직 관리자만접근해야함 session정보(mem_id)가들어가지않음)
    @PostMapping("insertFaqByMng")
    public String insertFaqByMng(@Valid @ModelAttribute("faqFormDto")FaqFormDto dto , BindingResult bresult,Model model,PaginationDto pDto){
        if(bresult.hasErrors()){
            List<DeptDto> dept = faqService.findDept();
            model.addAttribute("dept", dept);
            return  "board/faqForm";
        }
        int count = faqService.insertFaq(dto,pDto);
        System.out.println("count : " + count);
        if(count>0){
           model.addAttribute("msg","등록성공");
           model.addAttribute("url","getFaqListManage?page="+count);
       }
       else{
           model.addAttribute("msg","등록실패");
       }
        return "alert";
    }

    //(자주묻는질문관리 -> 수정폼)(A_0006)(오직 관리자만접근해야함 session정보(mem_id)가들어가지않음)
    @GetMapping("getFaqEditForm")
    public String getFaqEditForm(@RequestParam("id") String faqId,
                                      @RequestParam(value = "page", defaultValue = "1") int currentPage,
                                      Model model){
        FaqFormDto dto = faqService.findById(faqId);
        List<DeptDto> deptDtos = faqService.deptAll();
        model.addAttribute("faq", dto);
        model.addAttribute("dept", deptDtos);
        return "board/faqEditForm";
    }

    //(자주묻는질문관리 -> 수정버튼)(A_0006)(오직 관리자만접근해야함 session정보(mem_id)가들어가지않음)
    @PostMapping("updateFaqByMng")
    public String updateFaqByMng(@Valid FaqFormDto dto, BindingResult bresult,Model model){
        if(bresult.hasErrors()){
            List<DeptDto> deptDtos = faqService.deptAll();
            model.addAttribute("faq", dto);
            model.addAttribute("dept", deptDtos);
            return "board/faqEditForm";
        }
        if(faqService.updateFaq(dto)){
            model.addAttribute("msg","업데이트성공");
        }
        else{
            model.addAttribute("msg","업데이트실패");
        }
        return "alert";
    }

    // (자주묻는질문관리 -> 삭제)(A_0006)(오직 관리자만접근해야함 session정보(mem_id)가들어가지않음)
    @GetMapping("deleteFaqByMng")
    public String deleteFaqByMng(@RequestParam("id") String faqId,
                                 @RequestParam(value = "page", defaultValue = "1") int currentPage,
                                 Model model){
        if(faqService.deleteFaq(faqId)){
            model.addAttribute("msg","삭제성공");
        }
        else{
            model.addAttribute("msg","삭제실패");
        }
        model.addAttribute("url","getFaqListManage?page="+currentPage);
        return "alert";
    }





}
