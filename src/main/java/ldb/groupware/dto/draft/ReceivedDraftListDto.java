package ldb.groupware.dto.draft;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@ToString
public class ReceivedDraftListDto {

    private String docId;
    private String formCode;
    private String docTitle;
    private LocalDate docEndDate;
    private String status;
    private String approval1Name;
    private String approval2Name;


}
