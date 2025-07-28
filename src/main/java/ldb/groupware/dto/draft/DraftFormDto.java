package ldb.groupware.dto.draft;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.domain.FormExpense;
import ldb.groupware.domain.FormProject;
import ldb.groupware.domain.FormResign;
import org.apache.commons.lang3.StringUtils;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@ToString
public class DraftFormDto {

    private Integer docId;

    private String memName;

    @NotBlank(message = "제목은 필수 입력입니다.")
    private String title;

    @NotBlank(message = "내용은 필수 입력입니다.")
    private String content;

    @NotBlank(message = "결재양식을 선택하세요.")
    private String formCode;

    private Integer status;

    @NotBlank(message = "1차 결재자를 선택하세요.")
    private String approver1;
    private String approver1Name;

    @NotBlank(message = "2차 결재자를 선택하세요.")
    private String approver2;
    private String approver2Name;

    @NotNull(message = "문서종료일을 입력하세요.")
    private LocalDate docEndDate;

    private String referrers;

    private String attachType = "D"; // 전자결재 첨부파일 타입

    // 휴가신청서
    private String leaveCode;
    private LocalDate leaveStart;
    private LocalDate leaveEnd;

    // 프로젝트 제안서
    private String projectName;
    private LocalDate projectStart;
    private LocalDate projectEnd;

    // 지출결의서
    private String exName;
    private Integer exAmount;
    private LocalDate useDate;

    // 사직서
    private LocalDate resignDate;

    // LocalDate -> String
    public String getLeaveStartStr() {
        return formatDate(leaveStart);
    }

    public String getLeaveEndStr() {
        return formatDate(leaveEnd);
    }

    public String getProjectStartStr() {
        return formatDate(projectStart);
    }

    public String getProjectEndStr() {
        return formatDate(projectEnd);
    }

    public String getUseDateStr() {
        return formatDate(useDate);
    }

    public String getResignDateStr() {
        return formatDate(resignDate);
    }

    public String getDocEndDateStr() {
        return formatDate(docEndDate);
    }

    private String formatDate(LocalDate date) {
        return date != null ? date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "";
    }

    public String getFormCodeStr() {
        switch (formCode) {
            case ApprovalConst.FORM_ANNUAL:
                return "휴가계획서";
            case ApprovalConst.FORM_PROJECT:
                return "프로젝트 제안서";
            case ApprovalConst.FORM_EXPENSE:
                return "지출결의서";
            case ApprovalConst.FORM_RESIGN:
                return "사직서";
            default:
                return "알수없는 양식";
        }
    }

    public double getTotalDays() {
        if (leaveStart == null || leaveEnd == null) {
            throw new IllegalArgumentException("휴가 시작일or종료일이 존재하지않습니다.");
        }

        return (double) ChronoUnit.DAYS.between(leaveStart, leaveEnd) + 1;
    }

    public List<String> getReferrerList() {
        if (StringUtils.isNotBlank(referrers)) {
            return Arrays.stream(referrers.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .collect(Collectors.toList());
        }
        return Collections.emptyList();
    }

//    양식별 데이터 세팅
    public void setAnnualData(FormAnnualLeave formAnnual) {
        leaveCode = formAnnual.getLeaveCode();
        leaveStart = formAnnual.getStartDate();
        leaveEnd = formAnnual.getEndDate();
    }

    public void setProjectData(FormProject formProject) {
        projectName = formProject.getProjectName();
        projectStart = formProject.getStartDate();
        projectEnd = formProject.getEndDate();
    }

    public void setExpenseData(FormExpense formExpense) {
        exName = formExpense.getExName();
        exAmount = formExpense.getExAmount();
        useDate = formExpense.getUseDate();
    }

    public void setresignData(FormResign formResign) {
        resignDate = formResign.getResignDate();
    }

}


