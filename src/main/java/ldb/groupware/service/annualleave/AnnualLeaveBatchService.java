package ldb.groupware.service.annualleave;

import ldb.groupware.domain.AnnualLeave;
import ldb.groupware.domain.Member;
import ldb.groupware.mapper.mybatis.annual.AnnualLeaveMapper;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AnnualLeaveBatchService {

    private final AnnualLeaveMapper annualLeaveMapper;

    /**
     * 매일 새벽 실행되는 연차 생성 배치
     * - 입사 후 1년 미만 직원: 매월 1일씩 누적
     * - 입사 후 1년 이상 직원: 입사 기념일에 정기연차 지급 (2년마다 1일씩 증가, 최대 25일까지)
     */
    public void generateAnnualLeave() {
        LocalDate today = LocalDate.now();
        int currentYear = today.getYear();

        List<Member> members = annualLeaveMapper.findAllActiveMembers(); // 재직 중인 사원 목록

        for (Member member : members) {
            String memId = member.getMemId();
            LocalDate hireDate = member.getMemHiredate();

            long years = ChronoUnit.YEARS.between(hireDate, today); // 근속 연수

            // 🟢 1년 미만 직원 → 매월 1일씩 누적
            if (years < 1) {
                long monthsPassed = ChronoUnit.MONTHS.between(
                        hireDate.withDayOfMonth(1),
                        today.withDayOfMonth(1)
                );

                // 조건: 1개월 이상 ~ 11개월 이하만
                if (monthsPassed < 1 || monthsPassed > 11) continue;

                AnnualLeave existing = annualLeaveMapper.selectByMemIdAndYear(memId, currentYear);
                double currentTotal = (existing != null) ? existing.getTotalDays() : 0.0;

                // 누적된 월 수가 현재 totalDate보다 크면 1일 추가 지급
                if (monthsPassed > currentTotal) {
                    if (existing == null) {
                        AnnualLeave newLeave = new AnnualLeave();
                        newLeave.setMemId(memId);
                        newLeave.setYear(currentYear);
                        newLeave.setTotalDays(1.0);
                        newLeave.setUseDays(0.0);
                        newLeave.setRemainDays(1.0);
                        newLeave.setCreatedAt(LocalDateTime.now());
                        newLeave.setCreatedBy("system");
                        annualLeaveMapper.insertAnnualLeave(newLeave);
                        log.info("[신규 생성] {} → 1년차 {}개월차 → 연차 1일 지급", memId, monthsPassed);
                    } else {
                        existing.setTotalDays(currentTotal + 1);
                        existing.setRemainDays(existing.getRemainDays() + 1);
                        existing.setUpdatedAt(LocalDateTime.now());
                        existing.setUpdatedBy("system");
                        annualLeaveMapper.updateAnnualLeave(existing);
                        log.info("[갱신] {} → {}개월차 → 누적 연차 {}일", memId, monthsPassed, currentTotal + 1);
                    }
                }
            }

            // 🟡 1년 이상 → 다음해 입사일에 정기연차 지급
            else {
                LocalDate anniversary = hireDate.plusYears(years);
                if (!today.equals(anniversary)) continue;

                // 정기연차 계산: 2년마다 1일씩 증가 (2~3년차:15일, 4~5년차:16일, ..., 최대 25일)
                int annualDays = Math.min(15 + (int) ((years - 1) / 2), 25);

                if (!annualLeaveMapper.existsByMemIdAndYear(memId, currentYear)) {
                    AnnualLeave al = new AnnualLeave();
                    al.setMemId(memId);
                    al.setYear(currentYear);
                    al.setTotalDays((double) annualDays);
                    al.setUseDays(0.0);
                    al.setRemainDays((double) annualDays);
                    al.setCreatedAt(LocalDateTime.now());
                    al.setCreatedBy("system");

                    annualLeaveMapper.insertAnnualLeave(al);
                    log.info("[정기 연차 지급] {} - {}년차 → 연차 {}일 지급", memId, years, annualDays);
                }
            }
        }
    }
}
