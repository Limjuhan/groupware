package ldb.groupware.util;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j; // Slf4j 로깅 라이브러리 임포트
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

@Slf4j // Slf4j 로거를 사용할 수 있도록 어노테이션 추가
@Component
public class MailUtil {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public MailUtil(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Async // 이 메서드를 비동기적으로 실행하도록 지시
    public void send(String to, String subject, String htmlContent) {
        long startTime = System.currentTimeMillis(); // 메서드 시작 시간 기록
        log.info("[MailUtil] 비동기 이메일 전송 작업 시작. To: {}, Subject: {}", to, subject);

        try {
            // MimeMessage 생성 및 설정
            MimeMessage message = mailSender.createMimeMessage();
            // MimeMessageHelper를 사용하여 편리하게 이메일 속성 설정
            // 두 번째 인자 false는 multipart (첨부파일)를 사용하지 않겠다는 의미
            // 세 번째 인자 "UTF-8"은 인코딩 설정
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

            helper.setTo(to); // 수신자 설정
            helper.setSubject(subject); // 제목 설정
            helper.setFrom(fromEmail, "LDBSOFT Groupware"); // 발신자 이메일 주소 및 이름 설정
            helper.setText(htmlContent, true); // 이메일 본문 설정 (true는 HTML 형식임을 의미)

            long buildTime = System.currentTimeMillis();
            log.debug("[MailUtil] MimeMessage 빌드 완료. 소요 시간: {}ms", buildTime - startTime);

            // 실제 메일 전송
            // 이 부분이 SMTP 서버와 통신하는 과정이므로 네트워크 지연이 발생할 수 있습니다.
            mailSender.send(message);

            long sendTime = System.currentTimeMillis();
            log.info("[MailUtil] 비동기 이메일 전송 완료. To: {}, 총 소요 시간: {}ms", to, sendTime - startTime);

        } catch (MessagingException e) {
            // 메일 발송 중 SMTP 관련 오류 발생 시
            log.error("[MailUtil] 메일 발송 실패 (MessagingException): To={}, Subject={}, Error={}", to, subject, e.getMessage(), e);
            // 호출자에게 예외를 다시 던져서 비동기 작업의 실패를 알림
            throw new RuntimeException("메일 발송 실패", e);
        } catch (Exception e) {
            // 그 외 예상치 못한 오류 발생 시
            log.error("[MailUtil] 메일 전송 중 예상치 못한 오류: To={}, Subject={}, Error={}", to, subject, e.getMessage(), e);
            // 호출자에게 예외를 다시 던져서 비동기 작업의 실패를 알림
            throw new RuntimeException("메일 전송 중 오류", e);
        }
    }
}