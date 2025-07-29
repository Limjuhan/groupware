package ldb.groupware.mapper.mybatis.facility;

import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import ldb.groupware.dto.facility.MyFacilityReserveDto;
import ldb.groupware.dto.facility.SearchDto;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FacilityMapper {

    public List<FacilityListDto> getList(@Param("pDto")PaginationDto dto , @Param("sDto")SearchDto searchDto);

    int insertFacility(FacilityRentDto dto);

    FacilityRentDto findById(String facId);

    int countByType(String type);

    int myReserveCount(String loginId);

    List<MyFacilityReserveDto> myReservedList(@Param("pDto")PaginationDto dto,
                                              @Param("sDto") SearchDto sDto,
                                              @Param("loginId") String loginId);

    int reserveCancel(@Param("loginId")String loginId,@Param("facId") String facId);
}
