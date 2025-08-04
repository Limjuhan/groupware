package ldb.groupware.mapper.mybatis.facility;

import ldb.groupware.dto.facility.*;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FacilityMapper {

    List<FacilityListDto> getList(@Param("pDto")PaginationDto dto , @Param("sDto")SearchDto searchDto);

    int insertFacility(FacilityRentDto dto);

    FacilityRentDto findById(String facId);

    int countByType(@Param("sDto") SearchDto searchDto);

    int myReserveCount(@Param("sDto") SearchDto sDto, @Param("loginId") String loginId);

    List<MyFacilityReserveDto> myReservedList(@Param("pDto")PaginationDto dto,
                                              @Param("sDto") SearchDto sDto,
                                              @Param("loginId") String loginId);

    int reserveCancel(@Param("loginId")String loginId,@Param("facId") String facId);

    int returnFacility(@Param("loginId")String loginId,@Param("facId") String facId);

    String maxFacId();

    int findUid(@Param("facType")String facType,@Param("facUid") String uid);

    int insertFacilityByMng(@Param("dto")FacilityFormDto dto,
                            @Param("loginId")String loginId  );

    int deleteFacilityByMng(@Param("facId")String facId,
                            @Param("loginId") String loginId);

    int findRentYn(String facId);



    int findFacUid(String facUid);

    List<MyFacilityReserveDto> selectReservations(@Param("loginId") String loginId);
}
