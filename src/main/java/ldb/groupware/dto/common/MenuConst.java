package ldb.groupware.dto.common;

public enum MenuConst {
    HOME("A_0000", new String[]{"/"}),
    MEMBER_INFO("A_0001", new String[]{
            "/member/getMemberInfo", "/member/updateMemberInfo", "/member/passEditForm", "/member/updatePass"
    }),
    BOARD_NOTICE("A_0002", new String[]{
            "/board/getNoticeList","/board/getNoticeDetail"
    }),
    BOARD_NOTICE_MANAGE("A_0003", new String[]{
            "/board/getNoticeForm", "/board/insertNotice",
            "/board/getNoticeEditForm", "/board/updateNoticeByMng",
            "/board/deleteNoticeByMng","/board/getNoticeDetail"
    }),
    BOARD_FAQ("A_0004", new String[]{"/board/getFaqList"}),
    BOARD_QNA("A_0005", new String[]{
            "/board/getQnaList", "/board/getQnaForm", "/board/insertQna",
            "/board/getQnaDetail", "/board/getQnaEditForm", "/board/updateQna",
            "/board/deleteQnaByMng", "/board/deleteCommentByMng"
    }),
    BOARD_FAQ_MANAGE("A_0006", new String[]{
            "/board/getFaqListManage", "/board/getFaqForm", "/board/insertFaqByMng",
            "/board/getFaqEditForm", "/board/updateFaqByMng", "/board/deleteFaqByMng"
    }),
    DRAFT_MY("A_0007", new String[]{
            "/draft/getMyDraftList", "/draft/draftForm", "/draft/insertMyDraft",
            "/draft/getMyDraftDetail", "/draft/deleteMyDraftByMng"
    }),
    DRAFT_RECEIVED("A_0008", new String[]{
            "/draft/receivedDraftList", "/draft/receivedDraftDetail", "/draft/updateDraft"
    }),
    FACILITY_VEHICLE("A_0009", new String[]{
            "/facility/getVehicleList", "/facility/insertFacilityRent"
    }),
    FACILITY_MEETING_ROOM("A_0010", new String[]{
            "/facility/getMeetingRoomList", "/facility/insertFacilityRent"
    }),
    FACILITY_ITEM("A_0011", new String[]{
            "/facility/getItemList", "/facility/insertFacilityItem"
    }),
    FACILITY_MY_RESERVATION("A_0012", new String[]{
            "/facility/getReservationList", "/facility/cancelReservation", "/facility/returnFacility","/facility/getReservationList/**"
    }),
    FACILITY_VEHICLE_MANAGE("A_0013", new String[]{
            "/facility/getVehicleManage", "/facility/getVehicleForm"
    }),
    FACILITY_MEETING_ROOM_MANAGE("A_0014", new String[]{
            "/facility/getMeetingRoomManage", "/facility/getMeetingRoomForm",
            "/facility/insertMeetingRoomByMng", "/facility/deleteFacilityByMng"
    }),
    FACILITY_ITEM_MANAGE("A_0015", new String[]{
            "/facility/getItemManage", "/facility/insertVehicleByMng", "/facility/insertItemByMng",
            "/facility/getItemForm"
    }),
    CALENDAR_VIEW("A_0016", new String[]{"/calendar/getCalendar"}),
    CALENDAR_MANAGE("A_0017", new String[]{
            "/calendar/getCalendarList", "/calendar/getCalendarForm", "/calendar/insertCalendarByMng",
            "/calendar/getCalendarEditForm", "/calendar/updateCalendarByMng"
    }),
    MEMBER_MANAGE("A_0018", new String[]{
            "/admin/getMemberList", "/admin/getMemberForm", "/admin/insertMemberByMng",
            "/admin/insertMemberForm"
    }),
    DEPT_AUTH("A_0019", new String[]{
            "/admin/getDeptAuthList", "/admin/getMenuForm", "/admin/insertMenu"
    }),
    ANNUAL_USAGE_RATE("A_0020", new String[]{
            "/admin/dashBoard"
    }),
    COMMON_CODE_MANAGER("A_0021", new String[]{"/admin/getCommType"});

    private final String value;
    private final String[] uris;

    MenuConst(String value, String[] uris) {
        this.value = value;
        this.uris = uris;
    }

    public String getValue() {
        return value;
    }

    public String[] getUris() {
        return uris;
    }

    public static String fromUri(String uri) {
        for (MenuConst menu : values()) {
            for (String pattern : menu.getUris()) {
                if (uri.equals(pattern)) {
                    return menu.getValue();
                }
            }
        }
        return "";
    }
}
