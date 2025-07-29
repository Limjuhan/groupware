package ldb.groupware.mapper.mybatis.draft;

import ldb.groupware.domain.FormAnnualLeave;
import ldb.groupware.domain.FormExpense;
import ldb.groupware.domain.FormProject;
import ldb.groupware.domain.FormResign;
import ldb.groupware.dto.draft.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DraftMapper {

    List<DraftListDto> getMyDraftList(@Param("dto") MyDraftSearchDto dto,
                                      @Param("memId") String memId);

    List<DraftForMemberDto> getMemberList();

    Integer getRemainAnnual(@Param("memId") String memId);

    void insertApprovalDocument(@Param("dto") DraftFormDto dto,
                                @Param("status") Integer status,
                                @Param("memId") String memId);

    void insertFormAnnualLeave(FormAnnualLeave formAnnualLeave);

    void insertApprovalLine(@Param("docId") Integer docId,
                            @Param("memId") String memId,
                            @Param("stepOrder") int stepOrder,
                            @Param("refYn") String refYn);

    FormAnnualLeave getFormAnnualLeave(Integer docId);

    FormProject getFormProject(Integer docId);

    FormExpense getFormExpense(Integer docId);

    FormResign getFormResign(Integer docId);

    DraftFormDto getApprovalDocumentByDocId(Integer docId);

    void updateApprovalDocument(@Param("dto") DraftFormDto dto,
                                @Param("status") int status,
                                @Param("memId") String memId);

    void updateFormAnnualLeave(FormAnnualLeave from);

    void updateFormProject(FormProject from);

    void updateFormExpense(FormExpense from);

    void updateFormResign(FormResign from);

    void insertFormResign(FormResign from);

    void insertFormProject(FormProject from);

    void insertFormExpense(FormExpense from);

    int getMyDraftCount(Map<String, Object> countParam);

    DraftFormDto getMyDraftDetail(Integer docId);

    int deleteApprovalDocument(DraftDeleteDto dto);

    int deleteFormAnnualLeave(Integer docId);

    int deleteFormProject(Integer docId);

    int deleteFormExpense(Integer docId);

    int deleteFormResign(Integer docId);

    int getReceivedDraftCount(@Param("dto") MyDraftSearchDto dto,
                              @Param("memId") String memId);

    List<DraftListDto> getReceivedDraftList(@Param("dto") MyDraftSearchDto dto,
                                            @Param("memId") String memId);
}
