package ldb.groupware.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> filter = new FilterRegistrationBean<>();
        filter.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                builder.addDecoratorPath("/*", "layout.jsp")
                        .addExcludedPath("/login/doLogin")

                        .addExcludedPath("/board/getFaqForm")
                    .addExcludedPath("/board/insertFaqByMng");

//                builder.addDecoratorPath("/mypage/getCourseTimetable","sitemesh/layout.jsp");



            }
        });
        return filter;
    }
}