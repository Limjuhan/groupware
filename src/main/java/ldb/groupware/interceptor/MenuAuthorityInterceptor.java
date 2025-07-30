package ldb.groupware.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.AuthDto;

import ldb.groupware.mapper.mybatis.menu.MenuAuthorityMapper;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.util.List;

@Component
public class MenuAuthorityInterceptor implements HandlerInterceptor {

    private final MemberService memberService;
    private final MenuAuthorityMapper menuAuthorityMapper;

    public MenuAuthorityInterceptor(MemberService memberService,
                                    MenuAuthorityMapper menuAuthorityMapper) {
        this.memberService = memberService;
        this.menuAuthorityMapper = menuAuthorityMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        String loginId = (String) session.getAttribute("loginId");

        // 부서 / 직급 조회
        AuthDto auth = memberService.selectAuth(loginId);

        // 현재 요청 URI → menu_code로 변환
        String menuCode = convertUriToMenuCode(request.getRequestURI());
        if (menuCode.isEmpty()) {
            return true; // menu_code 매핑이 없는 URI는 그냥 통과
        }

        // DB에서 허용된 메뉴 목록 조회
        List<String> allowedMenus = menuAuthorityMapper.selectAllowedMenus(auth.getDeptId(), auth.getRankId());

        // 권한이 없는 경우
        if (!allowedMenus.contains(menuCode)) {
            String url = "/";
            String msg = "접근 권한이 없습니다.";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, "UTF-8"));
            return false;
        }

        return true;
    }

    private String convertUriToMenuCode(String uri) {
        // 프로젝트 메뉴 구조에 맞게 직접 매핑
        if (uri.startsWith("/admin/member")) return "MEMBER_MANAGE";
        if (uri.startsWith("/calendar")) return "CALENDAR";
        if (uri.startsWith("/approval")) return "APPROVAL";
        if (uri.startsWith("/admin/deptAuth")) return "DEPT_AUTH";
        return "";
    }
}
