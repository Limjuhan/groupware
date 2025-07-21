package ldb.groupware.controller.board;


import ldb.groupware.dto.common.PaginationDto;
import ldb.groupware.service.board.NoticeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
            @RequestParam(value="searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword , Model model ) {
        System.out.println(searchType);
        System.out.println(keyword);
        PaginationDto paging = new PaginationDto();
        paging.setPage(currentPage);
        paging.setSearchType(searchType);
        paging.setKeyword(keyword);
        Map<String,Object> map =service.getNoticeList(paging);
        model.addAttribute("notice",map.get("notice"));
        model.addAttribute("pageDto",map.get("pageDto"));

        return "board/getNoticeList";
    }
}
