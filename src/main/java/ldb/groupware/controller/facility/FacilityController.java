package ldb.groupware.controller.facility;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import ldb.groupware.dto.facility.CommTypeDto;
import ldb.groupware.dto.facility.FacilityFormDto;
import ldb.groupware.dto.facility.FacilityRentDto;
import ldb.groupware.dto.facility.SearchDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.service.facility.FacilityService;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.Map;


@RequestMapping("facility/")
@Controller
public class FacilityController {

    private final FacilityService service;
    private final MemberService memberService;

    public FacilityController(FacilityService service, MemberService memberService) {
        this.memberService = memberService;
        this.service = service;
    }

    //차량예약 페이지(A_0009)
    @GetMapping("getVehicleList")
    public String getVehicleList(Model model, PaginationDto pageDto, SearchDto searchDto) {
        searchDto.setFacType(CommTypeDto.VEHICLE_TYPE);
        Map<String, Object> map = service.getFacilityList(pageDto, searchDto);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/vehicleList";

    }

    //예약버튼을 누르면 타는 메서드 (A_0009 , A_0010 , A_0011)
    @PostMapping("insertFacilityRent")
    public String insertFacility(FacilityRentDto dto, Model model) {
        if (service.insertFacility(dto)) {
            model.addAttribute("msg", "예약성공");
            model.addAttribute("url", "getReservationList");
        } else {
            model.addAttribute("msg", "예약실패");
            model.addAttribute("url", "getVehicleList");
        }
        return "alert";
    }

    //회의실 예약페이지(A_0010)
    @GetMapping("getMeetingRoomList")
    public String getMeetingRoomList(Model model, PaginationDto dto, SearchDto dto2) {
        dto2.setFacType(CommTypeDto.ROOM_TYPE);
        Map<String, Object> map = service.getFacilityList(dto, dto2);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/meetingRoomList";
    }

    //비품예약페이지 (A_0011)
    @GetMapping("getItemList")
    public String getItemList(Model model, PaginationDto dto, SearchDto dto2) {
        dto2.setFacType(CommTypeDto.ITEM_TYPE);
        Map<String, Object> map = service.getFacilityList(dto, dto2);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/itemList";
    }

    //내 예약내역(A_0012)
    @GetMapping("getReservationList")
    public String getReservationList(Model model, PaginationDto dto, SearchDto sDto, HttpServletRequest request) {
        System.out.println("sdto :: " + sDto);
        Map<String, Object> map = service.getReserveList(dto, sDto, request);
        model.addAttribute("pageDto", map.get("pageDto"));
        model.addAttribute("facility", map.get("facility"));
        return "facility/reservationList";
    }

    //내예약내역 -> 삭제 (A_0012)
    @GetMapping("cancelReservation")
    public String cancelReservation(Model model, @RequestParam("facId") String facId, HttpServletRequest request) {
        if (service.reserveCancel(facId, request)) {
            model.addAttribute("msg", "삭제성공");
        } else {
            model.addAttribute("msg", "삭제실패");
        }
        model.addAttribute("url", "getReservationList");
        return "alert";
    }


    //반납(A_0012( 내예약내역))
    @GetMapping("returnFacility")
    public String returnFacility(Model model, @RequestParam("facId") String facId, HttpServletRequest request) {
        if (service.returnFacility(facId, request)) {
            model.addAttribute("msg", "반납 성공");
        } else {
            model.addAttribute("msg", "반납실패");
        }
        model.addAttribute("url", "getReservationList");
        return "alert";
    }

    //회의실관리(A_0014)
    @GetMapping("getMeetingRoomManage")
    public String getMeetingRoomManage(Model model, PaginationDto pDto, SearchDto sDto, HttpServletRequest request) {
        sDto.setFacType(CommTypeDto.ROOM_TYPE);
        Map<String, Object> map = service.getFacilityList(pDto, sDto);
        model.addAttribute("meetingRooms", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/meetingRoomManage";
    }

    //회의실관리->등록페이지(A_0014)
    @GetMapping("getMeetingRoomForm")
    public String getMeetingRoomForm(Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        model.addAttribute("facilityFormDto", new FacilityFormDto());
        //아이디검증 필요
        return "facility/meetingRoomRegisterForm";
    }

    //회의실관리->등록처리(A_0014)
    @PostMapping("insertMeetingRoomByMng")
    public String insertMeetingRoomMng(@Valid @ModelAttribute FacilityFormDto dto,
                                       BindingResult bindingResult, Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if (bindingResult.hasErrors()) {
            return "facility/meetingRoomRegisterForm";
        }
        dto.setFacType(CommTypeDto.ROOM_TYPE);
        if (service.insertFacilityByMng(dto, loginId)) {
            model.addAttribute("msg", "등록 성공");
        } else {
            model.addAttribute("msg", "등록 실패");
        }
        model.addAttribute("url", "getMeetingRoomManage");
        return "alert";
    }

    //회의실관리->삭제 처리(A_0014)
    @GetMapping("deleteFacilityByMng")
    public String deleteFacilityByMng(@RequestParam("facId") String facId, @RequestParam("facType") String facType,
                                      HttpServletRequest request, Model model) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        //만든사람만 삭제할수있게해야할지 모호함
        if (service.deleteFacilityByMng(facId, loginId)) {
            model.addAttribute("msg", "삭제성공");
        } else {
            model.addAttribute("msg", "삭제실패");
        }
        String url = "";
        switch (facType) {
            case CommTypeDto.ROOM_TYPE -> url = "getMeetingRoomManage";
            case CommTypeDto.ITEM_TYPE -> url = "getItemManage";
            case CommTypeDto.VEHICLE_TYPE -> url = "getVehicleManage";
        }
        model.addAttribute("url", url);
        return "alert";
    }

    //비품관리(A_0015)
    @GetMapping("getItemManage")
    public String getItemManage(Model model, PaginationDto pDto, SearchDto sDto, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        sDto.setFacType(CommTypeDto.ITEM_TYPE);
        Map<String, Object> map = service.getFacilityList(pDto, sDto);
        model.addAttribute("items", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/itemManage";
    }

    //비품관리->등록(A_0015)
    @GetMapping("getItemForm")
    public String getItemForm(Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        model.addAttribute("facilityFormDto", new FacilityFormDto());
        return "facility/itemRegisterForm";
    }

    //비품관리->등록(A_0015)
    @PostMapping("insertItemByMng")
    public String insertItemByMng(@Valid @ModelAttribute FacilityFormDto dto,
                                  BindingResult bindingResult, Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if (bindingResult.hasErrors()) {
            System.err.println("에러발생");
            return "facility/itemRegisterForm";
        }
        dto.setFacType(CommTypeDto.ITEM_TYPE);
        if (service.insertFacilityByMng(dto, loginId)) {
            model.addAttribute("msg", "등록 성공");
        } else {
            model.addAttribute("msg", "등록 실패");
        }
        model.addAttribute("url", "getItemManage");
        return "alert";
    }


    //차량관리 (A_0013
    @GetMapping("getVehicleManage")
    public String getVehicleManage(Model model, PaginationDto pDto, SearchDto sDto, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        sDto.setFacType(CommTypeDto.VEHICLE_TYPE);
        Map<String, Object> map = service.getFacilityList(pDto, sDto);
        model.addAttribute("facility", map.get("list"));
        model.addAttribute("pageDto", map.get("pageDto"));
        return "facility/vehicleManage";
    }

    //차량관리->등록 (A_0013)
    @GetMapping("getVehicleForm")
    public String getVehicleForm(Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        model.addAttribute("facilityFormDto", new FacilityFormDto());
        return "facility/vehicleRegisterForm";
    }

    // 차량 관리->등록(A_0015)
    @PostMapping("insertVehicleByMng")
    public String insertVehicleByMng(@Valid @ModelAttribute FacilityFormDto dto,
                                     BindingResult bindingResult, Model model, HttpServletRequest request) {
        String loginId = (String) request.getSession().getAttribute("loginId");
        if (bindingResult.hasErrors()) {
            System.err.println("에러발생");
            return "facility/vehicleRegisterForm";
        }
        String pattern = "^[0-9]{2,3}[가-힣][0-9]{4}$";
        if (!dto.getFacUid().matches(pattern)) { //(2~3자리 + 모든한글1글자 + 4자리숫자) 차량번호유효성검사
            bindingResult.rejectValue("facUid", "error.car.mismatch");
            return "facility/vehicleRegisterForm";
        }
        dto.setFacType(CommTypeDto.VEHICLE_TYPE);
        String msg = service.insertVehicleByMng(dto, loginId);
        model.addAttribute("msg", msg);
        model.addAttribute("url", "getVehicleManage");
        return "alert";
    }


}
