package ldb.groupware.service.facility;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.facility.FacilityListDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import ldb.groupware.dto.facility.MyFacilityReserveDto;
import ldb.groupware.dto.facility.SearchDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.facility.FacilityMapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FacilityService {

    private final FacilityMapper facilityMapper;


    public FacilityService(FacilityMapper facilityMapper) {
        this.facilityMapper = facilityMapper;
    }

    //모든 공용설비예약리스틀 페이징처리해 뽑기위함
    public Map<String,Object>  getFacilityList(PaginationDto dto, SearchDto dto2) {
        System.out.println("dto2 :: "+dto2);
        Map<String,Object> map = new HashMap<>();
            if(dto.getPage()==0){ //페이지를 따로지정하지않았다면 기본페이지인 1
                dto.setPage(1);
            }
            int totalRow = facilityMapper.countByType(dto2.getFacType());
            dto.setTotalRows(totalRow);
            dto.calculatePagination();
            map.put("pageDto",dto);
            System.out.println("pageDto : "+dto);

        List<FacilityListDto> list = facilityMapper.getList(dto,dto2);
        System.out.println("list입니다 : "+list);
        map.put("list", list);
        return  map;
    }

    public boolean insertFacility(FacilityRentDto dto) {
        FacilityRentDto fDto = facilityMapper.findById(dto.getFacId());
        fDto.setRenterId(dto.getRenterId());
        fDto.setRentalPurpose(dto.getRentalPurpose());
        fDto.setStartAt(dto.getStartAt());
        fDto.setEndAt(dto.getEndAt());
        fDto.setCancelStatus("N");
        if(facilityMapper.insertFacility(fDto)>0){
            return true;
        }
        else{
            return false;
        }
    }

    //내가 예약한 리스트를 뽑아오기
    //dto : 페이징관련
    //searchDto : 차랑의유형(R_001 , R_002 ..) + yearMonth 가 들어있음
    public Map<String, Object> getReserveList(PaginationDto dto,SearchDto sDto, HttpServletRequest request) {

        String loginId = (String)request.getSession().getAttribute("loginId");
        HashMap<String, Object> map = new HashMap<>();
        if(dto.getPage()==0){
            dto.setPage(1);
        }
        int num  = facilityMapper.myReserveCount(loginId);
        System.out.println("getReserveList num : "+num);
        dto.setTotalRows(num);
        dto.calculatePagination();
        map.put("pageDto",dto);

        //내예약리스트
        //sDto.setRentYn("N"); //반납한게  뜨면 안되겠죠
        List<MyFacilityReserveDto> facility =  facilityMapper.myReservedList(dto,sDto,loginId);
        map.put("facility", facility);
        System.out.println("pageDto : "+dto);
        System.out.println("facility : "+facility);
        return map;
    }

    //예약취소
    public boolean reserveCancel(String facId, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if(facilityMapper.reserveCancel(loginId,facId)>0){
            return true;
        }
        else{
            return false;
        }
    }

    //반납
    public boolean returnFacility(String facId, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if(facilityMapper.returnFacility(loginId,facId)>0){
            return true;
        }
        else{
            return false;
        }
    }
}
