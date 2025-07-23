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

    private String leaveType;
    private LocalDate leaveStart;
    private LocalDate leaveEnd;

    // 프로젝트 제안서
    private String projectTitle;
    private String expectedDuration;
    private String projectGoal;

    // 지출결의서
    private String expenseItem;
    private Integer amount;
    private LocalDate usedDate;

    // 사직서
    private LocalDate resignDate;
    private String resignReason;
}


