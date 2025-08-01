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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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

        // 세션 체크
        if (session == null || session.getAttribute("loginId") == null) {
            String msg = "로그인 후 이용 부탁드립니다.";
            String url = "/login/doLogin";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        String loginId = (String) session.getAttribute("loginId");

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        if (ctx != null && !ctx.isEmpty() && uri.startsWith(ctx)) {
            uri = uri.substring(ctx.length());
        }

        String ajaxHeader = request.getHeader("X-Requested-With");

        if ("XMLHttpRequest".equalsIgnoreCase(ajaxHeader) ||
                uri.contains("cdn.jsdelivr.net") ||
                uri.startsWith("/calendar/getScheduleList")) {
            return true;
        }

        if ("admin".equalsIgnoreCase(loginId)) {
            return true; // 모든 권한 통과
        }

        AuthDto auth = memberService.selectAuth(loginId);

        // 부서별 기본 권한 조회
        List<String> allowedMenus = menuAuthorityMapper.selectAllowedMenus(auth.getDeptId(), auth.getRankId());
        request.setAttribute("allowedMenus", allowedMenus);

        // admin이 아닌 경우에만 차단
        Set<String> adminAuth = new HashSet<>(List.of("A_0021", "A_0019")); // 차단할 메뉴
        if (!"admin".equalsIgnoreCase(loginId)) {
            String menuCode = MenuConst.fromUri(uri);
            if (menuCode != null && !menuCode.isEmpty() && adminAuth.contains(menuCode)) {
                String msg = "해당 페이지에 대한 접근 권한이 없습니다. (관리자 전용)";
                response.sendRedirect("/alert?url=/&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
                return false;
            }
        }

        // 기본 권한 체크
        String menuCode = MenuConst.fromUri(uri);
        if (!allowedMenus.contains(menuCode)) {
            String msg = "해당 페이지의 접속 권한이 없습니다.";
            response.sendRedirect("/alert?url=/&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        return true;
    }
}