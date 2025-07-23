package ldb.groupware.dto.draft;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.time.LocalDate;

@Data
public class DraftFormDto {

    @NotBlank(message = "제목은 필수 입력입니다.")
    private String title;

    @NotBlank(message = "내용은 필수 입력입니다.")
    private String content;

    @NotBlank(message = "결재양식을 선택하세요.")
    private String formType;

    @NotBlank(message = "1차 결재자를 선택하세요.")
    private String approver1;

    @NotBlank(message = "2차 결재자를 선택하세요.")
    private String approver2;

    @NotNull(message = "문서종료일을 입력하세요.")
    private LocalDate deadline;

    private String referrers;

    // 휴가신청서
    @NotBlank(message = "휴가 종료류를 선택하세요.")
    private String leaveType;

    @NotNull(message = "휴가 시작일을 지정하세요.")
    private LocalDate leaveStart;

    @NotNull(message = "휴가 마감일 선택하세요.")
    private LocalDate leaveEnd;

    // 프로젝트 제안서
    private String projectTitle;

    @NotBlank(message = "기간입력은 필수입니다.")
    private String expectedDuration;

    private String projectGoal;

    // 지출결의서
    @NotBlank(message = "지출항목을 입력해주세요.")
    private String expenseItem;

    @NotNull(message = "금액은 필수입니다.")
    @Positive(message = "금액은 0보다 커야 합니다.")
    private Integer amount;

    private LocalDate usedDate;

    // 사직서
    @NotNull(message = "퇴직 희망일을 입력해주세요.")
    private LocalDate resignDate;

    private String resignReason;
}


