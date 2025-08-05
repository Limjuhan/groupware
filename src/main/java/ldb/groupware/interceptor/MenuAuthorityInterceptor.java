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
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        // contextPath 제거
        if (ctx != null && !ctx.isEmpty() && uri.startsWith(ctx)) {
            uri = uri.substring(ctx.length());
        }

        // ===== 로그인 여부 체크 =====
        if (session == null || session.getAttribute("loginId") == null) {
            if ("/".equals(uri) || "/home".equals(uri)) {
                response.sendRedirect("/login/doLogin");
            } else {
                response.sendRedirect("/login/doLogin");
            }
            return false;
        }

        String loginId = (String) session.getAttribute("loginId");

        // =====  Ajax / 허용 예외 URI 체크 =====
        String ajaxHeader = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(ajaxHeader) ||
                uri.contains("cdn.jsdelivr.net") ||
                uri.startsWith("/calendar/getScheduleList")) {
            return true;
        }

        // ===== 관리자(admin)는 전체 통과 =====
        if ("admin".equalsIgnoreCase(loginId)) {
            return true;
        }

        // =====사용자 권한 조회 =====
        AuthDto auth = memberService.selectAuth(loginId);
        List<String> allowedMenus = menuAuthorityMapper.selectAllowedMenus(auth.getDeptId(), auth.getRankId());
        request.setAttribute("allowedMenus", allowedMenus);

        // ===== 관리자 전용 메뉴 차단 =====
        Set<String> adminAuth = new HashSet<>(List.of("A_0021", "A_0019")); // 차단할 메뉴 코드
        String menuCode = MenuConst.fromUri(uri);
        if (menuCode != null && !menuCode.isEmpty() && adminAuth.contains(menuCode)) {
            String msg = "해당 페이지에 대한 접근 권한이 없습니다. (관리자 전용)";
            String url = "/home";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        // =====기본 권한 체크 =====
        if (menuCode != null && !allowedMenus.contains(menuCode)) {
            String msg = "해당 페이지의 접속 권한이 없습니다.";
            String url = "/home";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        return true;
    }
}
