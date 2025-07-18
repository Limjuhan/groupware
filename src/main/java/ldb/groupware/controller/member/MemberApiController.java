package ldb.groupware.controller.member;

import ldb.groupware.dto.member.MemberListDto;
import ldb.groupware.service.member.MemberService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/member")
public class MemberApiController {

    private final MemberService service;

    public MemberApiController(MemberService memberService) {
        this.service = memberService;
    }

//    @GetMapping("searchMembers")
//    public List<MemberListDto>  searchMembers(
//
//    )
}
