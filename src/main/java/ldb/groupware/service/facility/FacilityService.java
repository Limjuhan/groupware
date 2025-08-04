package ldb.groupware.service.facility;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.facility.*;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.facility.FacilityMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Service
public class FacilityService {

    private final FacilityMapper facilityMapper;


    public FacilityService(FacilityMapper facilityMapper) {
        this.facilityMapper = facilityMapper;
    }

    //모든 공용설비예약리스틀 페이징처리해 뽑기위함
    public Map<String, Object> getFacilityList(PaginationDto dto, SearchDto dto2) {
        System.out.println("dto2 :: " + dto2);
        Map<String, Object> map = new HashMap<>();
        if (dto.getPage() == 0) { //페이지를 따로지정하지않았다면 기본페이지인 1
            dto.setPage(1);
        }
        int totalRow = facilityMapper.countByType(dto2);
        dto.setTotalRows(totalRow);
        dto.setItemsPerPage(8);
        dto.calculatePagination();
        map.put("pageDto", dto);
        System.out.println("pageDto : " + dto);

        List<FacilityListDto> list = facilityMapper.getList(dto, dto2);
        System.out.println("list입니다 : " + list);
        map.put("list", list);
        return map;
    }

    public boolean insertFacility(FacilityRentDto dto) {
        FacilityRentDto fDto = facilityMapper.findById(dto.getFacId());
        fDto.setRenterId(dto.getRenterId());
        fDto.setRentalPurpose(dto.getRentalPurpose());
        fDto.setStartAt(dto.getStartAt());
        fDto.setEndAt(dto.getEndAt());
        fDto.setCancelStatus("N");
        if (facilityMapper.insertFacility(fDto) > 0) {
            return true;
        } else {
            return false;
        }
    }

    //내가 예약한 리스트를 뽑아오기
    //dto : 페이징관련
    //searchDto : 차랑의유형(R_001 , R_002 ..) + yearMonth 가 들어있음
    public Map<String, Object> getReserveList(PaginationDto dto, SearchDto sDto, HttpServletRequest request) {

        String loginId = (String) request.getSession().getAttribute("loginId");
        HashMap<String, Object> map = new HashMap<>();
        if (dto.getPage() == 0) {
            dto.setPage(1);
        }
        int num = facilityMapper.myReserveCount(sDto,loginId);
        System.out.println("getReserveList num : " + num);
        dto.setTotalRows(num);
        dto.calculatePagination();
        map.put("pageDto", dto);

        //내예약리스트
        //sDto.setRentYn("N"); //반납한게  뜨면 안되겠죠
        List<MyFacilityReserveDto> facility = facilityMapper.myReservedList(dto, sDto, loginId);
        map.put("facility", facility);
        System.out.println("pageDto : " + dto);
        System.out.println("facility : " + facility);
        return map;
    }

    //예약취소 (cancel_status = 'Y' and rent_yn = 'Y')
    public boolean reserveCancel(String facId, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if (facilityMapper.reserveCancel(loginId, facId) > 0) {
            return true;
        } else {
            return false;
        }
    }

    //반납( rent_yn = 'Y')
    public boolean returnFacility(String facId, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if (facilityMapper.returnFacility(loginId, facId) > 0) {
            return true;
        } else {
            return false;
        }
    }

    //facId생성 (maxNum을 꺼내와 숫자부분만 +1)
    public String makeFacId() {
        String maxFacId = facilityMapper.maxFacId();
        String num = maxFacId.substring(1);
        Integer id = Integer.valueOf(num);
        id = id + 1;
        String facId = id.toString();
        //우리공용설비 ID는 3자리로이루어져있음
        //ex) 002의 값을 기대하지만 실제로는 2가 나올거임
        // 방안 : 길이가 3이 될떄까지 앞에 '0'을 붙여줌
        while (facId.length() < 3) {
            facId = "0" + facId;
        }
        facId = "f" + facId;
        return facId;
    }

    //중복검사+UID생성 (회의실,비품)
    public String makeUid(String facType) {
        String uidType = "";
        switch (facType) { //facType에 따라 UID명이 다르므로
            case CommTypeDto.ROOM_TYPE -> uidType = CommTypeDto.ROOM_UID;
            case CommTypeDto.ITEM_TYPE -> uidType = CommTypeDto.ITEM_UID;
        }
        String uid = "";
        Random random = new Random();
        while (true) {
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < 3; i++) { //랜덤한3자리숫자
                builder.append(random.nextInt(10));
            }
            String ranNum = builder.toString();
            uid = uidType + ranNum;

            if (facilityMapper.findUid(facType, uid) < 1) {
                break;
            }
        }
        return uid;
    }

    public boolean insertFacilityByMng(FacilityFormDto dto, String loginId) {
        dto.setFacId(makeFacId());//fac_id(공용설비ID)생성
        dto.setFacUid(makeUid(dto.getFacType())); //uid생성
        System.out.println("insertFacilityByMng->dto : " + dto);
        if (facilityMapper.insertFacilityByMng(dto, loginId) > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean deleteFacilityByMng(String facId, String loginId) {
        int rentYn = facilityMapper.findRentYn(facId);
        System.out.println("rentYN : " + rentYn);
        if (facilityMapper.findRentYn(facId) < 1) {
            if (facilityMapper.deleteFacilityByMng(facId, loginId) > 0) {
                return true;
            } else {
                return false;
            }
        } else {
            System.err.println("반납되지않은 공용설비( " + facId + ")");
            return false;
        }
    }


    public String insertVehicleByMng(FacilityFormDto dto, String loginId) {
        return null;
    }

    public List<MyFacilityReserveDto> getLatestReservations(String loginId) {
        return facilityMapper.selectReservations(loginId);
    }
}
