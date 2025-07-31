package ldb.groupware.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.member.AuthDto;
import ldb.groupware.mapper.mybatis.menu.MenuAuthorityMapper;
import ldb.groupware.service.member.MemberService;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class MenuAuthorityInterceptor implements HandlerInterceptor {

    private final MemberService memberService;
    private final MenuAuthorityMapper menuAuthorityMapper;

    public MenuAuthorityInterceptor(MemberService memberService, MenuAuthorityMapper menuAuthorityMapper) {
        this.memberService = memberService;
        this.menuAuthorityMapper = menuAuthorityMapper;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        // 로그인 체크
        if (session == null || session.getAttribute("loginId") == null) {
            String msg = "로그인 후 이용 부탁드립니다.";
            String url = "/login/doLogin";
            response.sendRedirect("/alert?url=" + url + "&msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return false;
        }

        String loginId = (String) session.getAttribute("loginId");

        String ajaxHeader = request.getHeader("X-Requested-With");
        String uri = request.getRequestURI();

        // FullCalendar CDN 및 정적 자원 우회
        if (uri.contains("cdn.jsdelivr.net")) {
            return true;
        }

        if ("XMLHttpRequest".equals(ajaxHeader) || uri.startsWith("/calendar/getScheduleList") || uri.startsWith("/draft/insertMyDraft")) {
            return true; // AJAX 요청은 인터셉터 우회
        }

        // 부서 / 직급 조회
        AuthDto auth = memberService.selectAuth(loginId);

        // 허용된 메뉴코드 조회 및 매핑
        List<String> allowedMenus = menuAuthorityMapper.selectAllowedMenus(auth.getDeptId(), auth.getRankId())
                .stream()
                .map(this::mapMenuCode) // 매핑 적용
                .collect(Collectors.toList());
        System.out.println("Mapped Allowed Menus: " + allowedMenus);

        // JSP에서 사용하도록 request scope에 저장
        request.setAttribute("allowedMenus", allowedMenus);

        // 요청한 메뉴코드 변환
        String menuCode = convertUriToMenuCode(request.getRequestURI());
        System.out.println("Converted Menu Code: " + menuCode);

        // 공용페이지나 홈은 패스
        if (uri.equals("/")) {
            menuCode = "HOME";
            return true;
        }

        // 권한 없으면 차단
        if (!allowedMenus.contains(menuCode)) {
            String msg = "해당 페이지의 접속 권한이 없습니다.";
            response.sendRedirect("/alert?url=/&msg=" + URLEncoder.encode(msg, "UTF-8"));
            return false;
        }

        return true;
    }

    private String mapMenuCode(String dbMenuCode) {
        switch (dbMenuCode) {
            case "A_000":
                return "HOME"; // 메인페이지
            case "A_0001":
                return "MEMBER_INFO"; // 개인정보
            case "A_0002":
                return "BOARD_NOTICE"; // 공지사항
//            case  "A_0003":
//                return "BOARD_NOTICE_MNG"; // 공지사항 관리
            case "A_0004":
                return "BOARD_FAQ"; // 자주묻는질문
            case "A_0005":
                return "BOARD_QNA"; // 질문게시판
            case "A_0006":
                return "BOARD_FAQ_MANAGE"; // FAQ 관리
            case "A_0007":
                return "DRAFT_MY"; // 내 전자결재
            case "A_0008":
                return "DRAFT_RECEIVED"; // 받은 전자결재
            case "A_0009":
                return "FACILITY_VEHICLE"; // 차량예약
            case "A_0010":
                return "FACILITY_MEETING_ROOM"; // 회의실예약
            case "A_0011":
                return "FACILITY_ITEM"; // 비품예약
            case "A_0012":
                return "FACILITY_MY_RESERVATION"; // 내 예약내역
            case "A_0013":
                return "FACILITY_VEHICLE_MANAGE"; // 차량관리
            case "A_0014":
                return "FACILITY_MEETING_ROOM_MANAGE"; // 회의실관리
            case "A_0015":
                return "FACILITY_ITEM_MANAGE"; // 비품관리
            case "A_0016":
                return "CALENDAR_VIEW"; // 캘린더
            case "A_0017":
                return "CALENDAR_MANAGE"; // 일정관리
            case "A_0018":
                return "MEMBER_MANAGE"; // 사원관리
            case "A_0019":
                return "DEPT_AUTH"; // 부서권한관리
            case "A_0020":
                return "ANNUAL_USAGE_RATE"; // 연차사용률
            default:
                return dbMenuCode;
        }
    }

    private String convertUriToMenuCode(String uri) {
        if (uri.startsWith("/member/getMemberInfo")
                || uri.startsWith("/member/updateMemberInfo")
                || uri.startsWith("/member/passEditForm")
                || uri.startsWith("/member/UpdatePass")
        ) {
            return "MEMBER_INFO";// 개인정보
        }
        if (uri.startsWith("/board/getNoticeList")
                || uri.startsWith("/board/getNoticeForm")
                || uri.startsWith("/board/insertNotice")
                || uri.startsWith("/board/getNoticeDetail")
                || uri.startsWith("/board/getNoticeEditForm")
                || uri.startsWith("/board/updateNoticeByMng")
                || uri.startsWith("/board/deleteNoticeByMng")
        ) {
            return "BOARD_NOTICE"; // 공지사항
        }
        if (uri.startsWith("/board/getFaqList"))
            return "BOARD_FAQ"; // 자주묻는질문
        if (uri.startsWith("/board/getQnaList")
                || uri.startsWith("/board/getQnaForm")
                || uri.startsWith("/board/insertQna")
                || uri.startsWith("/board/getQnaDetail")
                || uri.startsWith("/board/getQnaEditForm")
                || uri.startsWith("/board/updateQna")
                || uri.startsWith("/board/deleteQnaByMng")
                || uri.startsWith("/board/deleteCommentByMng")
        ) {
            return "BOARD_QNA"; // 질문게시판
        }
        if (uri.startsWith("/board/getFaqListManage")
                || uri.startsWith("/board/getFaqForm")
                || uri.startsWith("/board/insertFaqByMng")
                || uri.startsWith("/board/getFaqEditForm")
                || uri.startsWith("/board/updateFaqByMng")
                || uri.startsWith("/board/deleteFaqByMng")
        ) {
            return "BOARD_FAQ_MANAGE"; // FAQ 관리
        }
        if (uri.startsWith("/draft/getMyDraftList")
                || uri.startsWith("/draft/draftForm")
                || uri.startsWith("/draft/insertMyDraft")
                || uri.startsWith("/draft/getMyDraftDetail")
                || uri.startsWith("/draft/deleteMyDraftByMng")
        ) {
            return "DRAFT_MY"; // 내 전자결재
        }
        if (uri.startsWith("/draft/receivedDraftList")
                || uri.startsWith("/draft/receivedDraftDetail")
                || uri.startsWith("/draft/updateDraft")
        ) {
            return "DRAFT_RECEIVED"; // 받은 전자결재
        }
        if (uri.startsWith("/facility/getVehicleList")
                || uri.startsWith("/facility/insertFacilityRent")
        ) {
            return "FACILITY_VEHICLE"; // 차량예약
        }
        if (uri.startsWith("/facility/getMeetingRoomList")
            || uri.startsWith("/facility/insertFacilityRent")
        ) {
            return "FACILITY_MEETING_ROOM"; // 회의실예약
        }
        if (uri.startsWith("/facility/getItemList")
                || uri.startsWith("/facility/insertFacilityItem")
        ) {
            return "FACILITY_ITEM"; // 비품예약
        }
        if (uri.startsWith("/facility/getReservationList")
                || uri.startsWith("/facility/cancelReservation")
                || uri.startsWith("/facility/returnFacility")
        ) {
            return "FACILITY_MY_RESERVATION"; // 내 예약내역
        }
        if (uri.startsWith("/facility/getVehicleManage")
                || uri.startsWith("/facility/getVehicleForm")
        ) {
            return "FACILITY_VEHICLE_MANAGE"; // 차량관리
        }
        if (uri.startsWith("/facility/getMeetingRoomManage")
                || uri.startsWith("/facility/getMeetingRoomForm")
                || uri.startsWith("/facility/insertMeetingRoomByMng")
                || uri.startsWith("/facility/deleteFacilityByMng")
        ) {
            return "FACILITY_MEETING_ROOM_MANAGE"; // 회의실관리
        }
        if (uri.startsWith("/facility/getItemManage")
                || uri.startsWith("/facility/insertVehicleByMng")
                || uri.startsWith("/facility/insertItemByMng")
                || uri.startsWith("/facility/getItemForm")
        ) {
            return "FACILITY_ITEM_MANAGE"; // 비품관리
        }
        if (uri.startsWith("/calendar/getCalendar")) {
            return "CALENDAR_VIEW"; // 캘린더
        }
        if (uri.startsWith("/calendar/getCalendarList")
                || uri.startsWith("/calendar/getCalendarForm")
                || uri.startsWith("/calendar/insertCalendarByMng")
                || uri.startsWith("/calendar/getCalendarEditForm")
                || uri.startsWith("/calendar/updateCalendarByMng")) {
            return "CALENDAR_MANAGE"; // 일정관리
        }

        if (uri.startsWith("/admin/getMemberList")
                || uri.startsWith("/admin/getMemberForm")
                || uri.startsWith("/admin/insertMemberByMng")
                || uri.startsWith("/admin/insertMemberForm")
        ) {
            return "MEMBER_MANAGE"; // 사원관리
        }
        if (uri.startsWith("/admin/getDeptAuthList")
                || uri.startsWith("/admin/getMenuForm")
                || uri.startsWith("/admin/insertMenu")
        ) {
            return "DEPT_AUTH"; // 부서권한관리
        }
        if (uri.startsWith("/admin/dashBoard")) {
            return "ANNUAL_USAGE_RATE"; // 연차사용률
        }
        if (uri.equals("/")) {
            return "HOME"; // 홈
        }

        return ""; // 기본값
    }
}