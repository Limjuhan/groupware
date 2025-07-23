//package ldb.groupware.config;
//
//import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
//import org.springframework.boot.web.server.WebServerFactoryCustomizer;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//@Configuration
//public class TomcatCustomizer {
//
//    @Bean(name = "customTomcatCustomizer")
//    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
//        return factory -> factory.addConnectorCustomizers(connector -> {
//            connector.setProperty("fileCountMax", "10000");  // 🔥 핵심: Tomcat 파서 설정
//            connector.setMaxPostSize(50 * 1024 * 1024);       // 50MB
//        });
//    }
//}
//
