package ldb.groupware.controller.draft;

import io.micrometer.common.util.StringUtils;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.draft.DraftListDto;
import ldb.groupware.service.draft.DraftService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/draft")
public class DraftApiController {

    private final DraftService draftService;

    public DraftApiController(DraftService draftService) {
        this.draftService = draftService;
    }

    @GetMapping("/searchMyDraftList")
    public List<DraftListDto> searchMyDraftList(@RequestParam String type,
                                                @RequestParam String keyword,
                                                HttpSession session) {

        List<DraftListDto> draftListDtos = null;

//        String memId = session.getAttribute("memId").toString();
        String memId = "user003";
        System.out.println("type = " + type);
        System.out.println("keyword = " + keyword);

        // 검색조건 없으면 전체 조회
        if (StringUtils.isBlank(type) || StringUtils.isBlank(keyword)) {
            draftListDtos = draftService.searchMyDraftList(memId, null, null);
        } else {
            draftListDtos = draftService.searchMyDraftList(memId, type, keyword);
        }

        draftListDtos.forEach(draftListDto -> {
            System.out.println("draftListDto = " + draftListDto);
        });

        return draftListDtos;
    }
}
