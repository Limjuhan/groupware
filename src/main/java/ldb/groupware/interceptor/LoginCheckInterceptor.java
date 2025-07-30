package ldb.groupware.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;

@Component
public class LoginCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginId") == null) {
            String msg = "로그인 후 이용 부탁드립니다.";
            String url = "/login/doLogin";
            response.sendRedirect("/alert?url=" + url + "&" + "msg=" + URLEncoder.encode(msg, "UTF-8"));
            return false;
        }
        return true;
    }
}
