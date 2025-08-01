package ldb.groupware.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.common.MenuConst;
import ldb.groupware.dto.member.AuthDto;
import ldb.groupware.mapper.mybatis.menu.MenuAuthorityMapper;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Component
public class MenuAuthorityInterceptor implements HandlerInterceptor {

    private final MemberService memberService;
    private final MenuAuthorityMapper menuAuthorityMapper;

    public MenuAuthorityInterceptor(MemberService memberService, MenuAuthorityMapper menuAuthorityMapper) {
        this.memberService = memberService;
        this.menuAuthorityMapper = menuAuthorityMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        // 로그인 체크
        if (session == null || session.getAttribute("loginId") == null) {
            String msg = "로그인 후 이용 부탁드립니다.";
            String url = "/login/doLogin";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        String loginId = (String) session.getAttribute("loginId");

        // 원본 URI
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }

        String ajaxHeader = request.getHeader("X-Requested-With");

        // **AJAX, 정적 자원, 예외 URI 먼저 우회**
        if ("XMLHttpRequest".equalsIgnoreCase(ajaxHeader) ||
                uri.contains("cdn.jsdelivr.net") ||
                uri.startsWith("/calendar/getScheduleList")) {
            return true;
        }

        // 부서 / 직급 조회
        AuthDto auth = memberService.selectAuth(loginId);

        // 허용된 메뉴코드 조회 (DB)
        List<String> allowedMenus = menuAuthorityMapper.selectAllowedMenus(auth.getDeptId(), auth.getRankId());
        request.setAttribute("allowedMenus", allowedMenus);

        // URI → 메뉴코드 변환
        String menuCode = MenuConst.fromUri(uri);

        // 권한 없으면 차단
        if (!allowedMenus.contains(menuCode)) {
            String msg = "해당 페이지의 접속 권한이 없습니다.";
            response.sendRedirect("/alert?url=/&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        return true;
    }

}
