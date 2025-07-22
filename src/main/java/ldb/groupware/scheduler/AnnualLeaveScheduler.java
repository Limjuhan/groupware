package ldb.groupware.scheduler;

import ldb.groupware.service.annualleave.AnnualLeaveBatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class AnnualLeaveScheduler {

    private final AnnualLeaveBatchService batchService;

    public AnnualLeaveScheduler(AnnualLeaveBatchService batchService) {
        this.batchService = batchService;
    }

    @Scheduled(cron = "0 0 3 * * *") // 매일 새벽 3시
    public void run() {
        batchService.generateAnnualLeave();
    }
}

