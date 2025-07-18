package ldb.groupware.service.member;

import ldb.groupware.dto.member.MemberInfoDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MemberService {

    private final MemberMapper memberMapper;
    public MemberService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    public MemberInfoDto getMemberInfo(String memId) {
        return memberMapper.selectMemberInfo(memId);
    }
}