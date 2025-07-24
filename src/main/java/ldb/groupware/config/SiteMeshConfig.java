package ldb.groupware.config;

import jakarta.servlet.Filter;
import jakarta.servlet.http.HttpServletRequest;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig  {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> filter = new FilterRegistrationBean<>();
        filter.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                builder.addDecoratorPath("/*", "layout.jsp")
                        .addExcludedPath("/login/*")

                        .addExcludedPath("/member/passEditForm")
                        .addExcludedPath("/member/UpdatePass")

                        .addExcludedPath("/board/getFaqForm")
                        .addExcludedPath("/board/insertFaqByMng")
                        .addExcludedPath("/board/getFaqEditForm")
                        .addExcludedPath("/board/updateFaqByMng")

                        .addExcludedPath("/board/getNoticeForm")
                        .addExcludedPath("/board/getNoticeEditForm")
                        .addExcludedPath("/board/insertNotice")
                        .addExcludedPath("/board/updateNoticeByMng");


//                builder.addDecoratorPath("/mypage/getCourseTimetable","sitemesh/layout.jsp");


            }
        });
        return filter;
    }








}