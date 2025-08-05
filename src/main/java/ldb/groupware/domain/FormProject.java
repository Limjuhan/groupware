package ldb.groupware.domain;
import ldb.groupware.dto.draft.DraftFormDto;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class FormProject {

    private Integer docId;
    private String formCode;
    private String projectName;
    private String proContent;
    private LocalDate startDate;
    private LocalDate endDate;

    public static FormProject from(DraftFormDto dto) {

        FormProject formProject = new FormProject();
        formProject.setDocId(dto.getDocId());
        formProject.setFormCode(dto.getFormCode());
        formProject.setProjectName(dto.getProjectName());
        formProject.setProContent(dto.getContent());
        formProject.setStartDate(dto.getProjectStart());
        formProject.setEndDate(dto.getProjectEnd());

        return formProject;
    }
}

