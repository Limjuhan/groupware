package ldb.groupware.dto.draft;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DraftDeleteDto {
    @NotNull
    private Integer docId;
    @NotBlank
    private String formCode;
    @NotNull
    private Integer status;
}
