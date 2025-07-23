package ldb.groupware.controller.member;

import ldb.groupware.service.member.MemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/member")
public class MemberApiController {

    private final MemberService service;

    public MemberApiController(MemberService memberService) {
        this.service = memberService;
    }

}
