package ldb.groupware.service.annualleave;

import ldb.groupware.domain.AnnualLeave;
import ldb.groupware.domain.Member;
import ldb.groupware.mapper.mybatis.annual.AnnualLeaveMapper;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import ldb.groupware.service.member.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@Slf4j
public class AnnualLeaveBatchService {

    private final AnnualLeaveMapper annualLeaveMapper;
    private final MemberMapper memberMapper;

    public AnnualLeaveBatchService(AnnualLeaveMapper annualLeaveMapper, MemberMapper memberMapper) {
        this.annualLeaveMapper = annualLeaveMapper;
        this.memberMapper = memberMapper;
    }

    @Transactional
    public void runAnnualLeaveBatch() {
        LocalDate today = LocalDate.now();
        log.info("[연차배치,{}] 프로세스 시작", today);
        List<Member> members = memberMapper.findAllActiveMembers();

        if (members == null || members.isEmpty()) {
            log.warn("[연차배치] - 사원목록 불러오기 실패");
            return;
        }

        for (Member member : members) {
            LocalDate hireDate = member.getMemHiredate();
            String memId = member.getMemId();

            if (hireDate == null || memId == null) {
                log.warn("[연차배치] 사원정보 미존재.memId={}, hireDate={}", memId, hireDate);
                continue;
            }

            // 근속년수
            long years = ChronoUnit.YEARS.between(hireDate, today);
            System.out.println("memId = " + memId);
            System.out.println("years = " + years);
            System.out.println("hireDate = " + hireDate);
            System.out.println("===================================================");
            try {
                if (years < 1) {// 1년차 직원
                    if (isMonthlyGivenDay(hireDate, today)) {
                        givenMonthlyAnnualLeave(memId, hireDate);
                    }
                } else { // 2년차 이상
                    if (isRegularAnnualGiveDay(hireDate, today, years)) {
                        giveRegularAnnualLeave(memId, hireDate, today);
                    }
                }
            } catch (Exception e) {
                log.error("[연차배치] - 배치오류- memId={}, hireDate={}, error={}",
                        memId, hireDate, e.getMessage());
            }
        }
    }

    private void givenMonthlyAnnualLeave(String memId, LocalDate hireDate) {
        int hireYear = hireDate.getYear();
        AnnualLeave leave = annualLeaveMapper.selectAnnualLeave(memId, hireYear);

        if (leave == null) {// 입사후 첫 연차 지급
            leave = new AnnualLeave(memId, hireYear, 1.0, 0.0, 1.0);
            annualLeaveMapper.insertAnnualLeave(leave);
            log.info("[연차배치] - 신규 월차 생성 - memId={}, year={}, total=1.0", memId, hireYear);
        } else {
            leave.updateMonthAnnualByBatch(leave.getTotalDays()+1, leave.getRemainDays());
            annualLeaveMapper.updateAnnualLeave(leave);
            log.info("[연차배치] - 월차 1일 추가 - memId={}, year={}, 누적={}, 잔여={}",
                    memId, hireYear, leave.getTotalDays(), leave.getRemainDays());
        }
    }

    private void giveRegularAnnualLeave(String memId, LocalDate hireDate, LocalDate today) {
        int year = today.getYear();
        long years = ChronoUnit.YEARS.between(hireDate, today);
        int totalAnnual = Math.min(15 + (int) ((years - 1) / 2), 25);

        AnnualLeave leave = annualLeaveMapper.selectAnnualLeave(memId, year);

        if (leave == null) {
            leave = new AnnualLeave(memId, year, (double) totalAnnual, 0.0, (double) totalAnnual);
            annualLeaveMapper.insertAnnualLeave(leave);
            log.info("[연차배치] - memId={}, year={}, 지급={}", memId, year, totalAnnual);
        } else {
            log.warn("정기 연차 지급일인데 이미 row 존재 - memId={}, year={}", memId, year);
            leave.updateRegularAnnualByBatch(leave.getTotalDays(), leave.getRemainDays());
            annualLeaveMapper.updateAnnualLeave(leave);
        }

    }

    private boolean isRegularAnnualGiveDay(LocalDate hireDate, LocalDate today, long years) {

        LocalDate anniversary = hireDate.plusYears(years);
        System.out.println("anniversary = " + anniversary);
        System.out.println("today = " + today);
        System.out.println("===============================================");
        // 윤년 2월29일에 입사한 직원은 28일기준으로 연차 계산.
        if (hireDate.getMonth() == Month.FEBRUARY && hireDate.getDayOfMonth() == 29) {
            return today.getMonth() == Month.FEBRUARY && today.getDayOfMonth() == 28;
        }

        return today.equals(anniversary);
    }

    private boolean isMonthlyGivenDay(LocalDate hireDate, LocalDate today) {
        // 윤년 2월29일에 입사한 직원은 28일기준으로 연차 계산.
        if (hireDate.getMonth() == Month.FEBRUARY && hireDate.getDayOfMonth() == 29) {
            return today.getMonth() == Month.FEBRUARY && today.getDayOfMonth() == 28;
        }
        return today.getDayOfMonth() == hireDate.getDayOfMonth()
                && ChronoUnit.MONTHS.between(hireDate, today) > 0
                && ChronoUnit.YEARS.between(hireDate, today) < 1;
    }
}


























