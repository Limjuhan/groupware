package ldb.groupware.service.annualleave;

import ldb.groupware.dto.admin.UpdateAnnualDto;
import ldb.groupware.mapper.mybatis.annual.AnnualLeaveMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

@Service
public class AnnualService {

    AnnualLeaveMapper annualLeaveMapper;

    public AnnualService(AnnualLeaveMapper annualLeaveMapper) {
        this.annualLeaveMapper = annualLeaveMapper;
    }


    public void updateAnnualLeave(UpdateAnnualDto dto, String  loginId) {
        System.out.println("파라미터확인dto = " + dto);

        validateAnnualData(dto);
        if (annualLeaveMapper.updateAnnualLeaveByDashboard(dto, loginId) != 1) {
            throw new RuntimeException("연차정보수정 실패.");
        }

    }

    private void validateAnnualData(UpdateAnnualDto dto) {
        double totalDays = dto.getTotalDays();
        double useDays = dto.getUseDays();
        double remainDays = dto.getRemainDays();

        if (StringUtils.isBlank(dto.getMemId())) {
            throw new IllegalArgumentException("회원정보가 존재하지 않습니다.");
        }

        // 유효성 검사
        if (totalDays < 0 || useDays < 0 || remainDays < 0) {
            throw new IllegalStateException("연차 일수는 0보다 작을 수 없습니다.");
        }

        if (totalDays == 0) {
            throw new IllegalStateException("총 연차 일수는 0보다 커야 합니다.");
        }

        if (useDays > totalDays) {
            throw new IllegalStateException("사용 연차 일수는 총 연차 일수를 초과할 수 없습니다.");
        }

        if (remainDays > totalDays) {
            throw new IllegalStateException("잔여 연차 일수는 총 연차 일수를 초과할 수 없습니다.");
        }

        if ((useDays + remainDays) != totalDays) {
            throw new IllegalStateException("사용일수와 잔여일수의 합은 총 연차 일수와 같아야 합니다.");
        }
    }
}
