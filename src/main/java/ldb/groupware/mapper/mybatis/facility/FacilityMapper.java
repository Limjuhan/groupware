package ldb.groupware.mapper.mybatis.facility;

import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FacilityMapper {

    public List<FacilityListDto> getList(String type);

    int insertFacility(FacilityRentDto dto);

    FacilityRentDto findById(String facId);
}
