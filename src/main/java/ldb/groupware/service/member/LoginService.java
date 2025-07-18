package ldb.groupware.service.member;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.domain.Member;
import ldb.groupware.dto.member.LoginUserDto;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;



@Service
@RequiredArgsConstructor
public class LoginService {

    private final MemberMapper memberMapper;

//    public boolean loginChk(HttpServletRequest request) {
//        LoginUserDto loginUser = (LoginUserDto) request.getSession().getAttribute("loggedInUser");
//        if (loginUser != null) {
//            return false;
//        } else {
//            return false;
//        }
//
//    }


    public LoginUserDto getLoginUserDto(String id, String password) {
        return memberMapper.selectLoginUser(id, password);
    }

    public void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public LoginUserDto toLoginUserDto(Member member) {
        LoginUserDto dto = new LoginUserDto();
        dto.setMemId(member.getMemId());
        dto.setMemName(member.getMemName());
        dto.setDeptId(member.getDeptId());
        dto.setRankId(member.getRankId());
        dto.setMemEmail(member.getMemEmail());
        dto.setMemPhone(member.getMemPhone());
        dto.setMemGender(member.getMemGender());
        dto.setMemAddress(member.getMemAddress());
        dto.setMemPicture(member.getMemPicture());
        dto.setMemStatus(member.getMemStatus());
        dto.setMemHiredate(member.getMemHiredate());
        dto.setResignDate(member.getResignDate());

        // 주민번호 앞자리로 생년월일 계산 (예: 900101 → 1990-01-01)
        if (member.getJuminFront() != null && member.getJuminFront().length() == 6) {
            String front = member.getJuminFront();
            String yy = front.substring(0, 2);
            String mm = front.substring(2, 4);
            String dd = front.substring(4, 6);

            // 성별 + 세기 판단 (예: 1 or 2 → 1900년대, 3 or 4 → 2000년대)
            String back = member.getJuminBack();
            String century = "19"; // 기본값
            if (back != null && back.length() > 0) {
                char genderCode = back.charAt(0);
                if (genderCode == '1' || genderCode == '2') {
                    century = "19";
                } else if (genderCode == '3' || genderCode == '4') {
                    century = "20";
                }
            }

            String birthDate = century + yy + "-" + mm + "-" + dd;
            dto.setBirthDate(birthDate);
        }

        return dto;
    }
}
