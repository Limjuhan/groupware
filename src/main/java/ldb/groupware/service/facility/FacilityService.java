package ldb.groupware.service.facility;

import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.mapper.mybatis.facility.FacilityMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FacilityService {

    private final FacilityMapper facilityMapper;


    public FacilityService(FacilityMapper facilityMapper) {
        this.facilityMapper = facilityMapper;
    }

    //제네릭메서드를 활용해 다양한타입의 매개변수를 받을수있음 (이걸로 모든공용설비리스트 처리예정)
    public <T> List<T>  getFacilityList(String type) {
        List<FacilityListDto> list = facilityMapper.getList(type);
        return (List<T>) list;
    }
}
