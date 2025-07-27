package ldb.groupware.mapper.mybatis.facility;

import ldb.groupware.dto.facility.FacilityListDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FacilityMapper {

    public List<FacilityListDto> getList(String type);
}
