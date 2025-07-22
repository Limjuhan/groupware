package ldb.groupware.config;

import jakarta.servlet.MultipartConfigElement;
import org.apache.coyote.http11.AbstractHttp11Protocol;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/N/**") //유형별로 이름 다르게
                .addResourceLocations("file:upload/notice/"); // 상대 경로

        registry.addResourceHandler("/Q/**")
                .addResourceLocations("file:upload/question/");

        registry.addResourceHandler("/D/**")
                .addResourceLocations("file:upload/draft/");

        registry.addResourceHandler("/P/**")
                .addResourceLocations("file:upload/profile/");

    }



}
