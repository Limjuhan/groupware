package ldb.groupware.config;

import jakarta.servlet.MultipartConfigElement;
import ldb.groupware.interceptor.LoginCheckInterceptor;
import ldb.groupware.interceptor.MenuAuthorityInterceptor;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final LoginCheckInterceptor loginCheckInterceptor;
    private final MenuAuthorityInterceptor menuAuthorityInterceptor;

    public WebConfig(LoginCheckInterceptor loginCheckInterceptor, MenuAuthorityInterceptor menuAuthorityInterceptor) {
        this.loginCheckInterceptor = loginCheckInterceptor;
        this.menuAuthorityInterceptor = menuAuthorityInterceptor;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        //클라이언트가 브라우저에서 /**/파일명 요청 시, 실제 서버의 upload/**/ 디렉토리에 있는 파일을 응답으로 보냄.
        registry.addResourceHandler("/N/**") //유형별로 이름 다르게
                .addResourceLocations("file:upload/notice/"); // 상대 경로

        registry.addResourceHandler("/Q/**")
                .addResourceLocations("file:upload/qna/");

        registry.addResourceHandler("/D/**")
                .addResourceLocations("file:upload/draft/");

        registry.addResourceHandler("/P/**")
                .addResourceLocations("file:upload/profile/");

    }

//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(loginCheckInterceptor)
//                .addPathPatterns("/member/**")
//                .addPathPatterns("/admin/**")
//                .addPathPatterns("/");
//
//    }

    @Bean
    public MultipartResolver multipartResolver() {
        StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
        return resolver;
    }

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize(DataSize.ofMegabytes(10));
        factory.setMaxRequestSize(DataSize.ofMegabytes(20));
        return factory.createMultipartConfig();
    }


}
