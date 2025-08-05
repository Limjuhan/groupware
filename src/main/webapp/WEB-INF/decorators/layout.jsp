<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title"/></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%; /* 전체 높이 고정 */
            background-color: #f8f9fa;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background-color: #4b5e8c;
            margin: 0;
            padding: 0.5rem 1rem;
            border-bottom: none;
        }

        .navbar-brand {
            font-weight: bold;
            color: #ffffff !important;
        }

        .navbar .btn-outline-danger {
            color: #ffffff;
            border-color: #ffffff;
        }

        .navbar .btn-outline-danger:hover {
            background-color: #dc3545;
            color: #ffffff;
            border-color: #dc3545;
        }

        .navbar .text-dark {
            color: #ffffff !important;
        }

        .sidebar {
            height: 100%;
            padding: 0.5rem 0;
            background-color: #2c3e50;
            border-right: 1px solid #2c3e50;
            overflow-y: auto;
        }

        .nav-pills .nav-link {
            color: #ffffff;
        }

        .nav-pills .nav-link.active {
            background-color: #17a2b8;
            color: #ffffff;
        }

        .nav-pills .nav-link:hover {
            background-color: #1a252f;
            color: #ffffff;
        }

        /* 페이지 전체 영역을 남는 공간 없이 꽉 채움 */
        .content-wrapper {
            flex: 1;
            display: flex;
            min-height: calc(100vh - 60px); /* 네비게이션 제외 */
            height: calc(100vh - 60px);
            overflow: hidden;
        }

        /* 컨텐츠 박스 - 여백 없이 꽉 차도록 */
        .page-container {
            flex: 1;
            min-height: 100%;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 0;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            overflow: auto;
        }

        /* 검색 결과 영역 */
        #searchResults {
            max-height: 200px;
            overflow-y: auto;
        }

        /* 알람 드롭다운 */
        #alarmList {
            min-width: 350px;
            max-height: 400px;
            overflow-y: auto;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 0;
        }

        #alarmList li {
            padding: 8px 12px;
            border-bottom: 1px solid #e9ecef;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #alarmList li:last-child {
            border-bottom: none;
        }

        #alarmList li:hover {
            background-color: #f1f3f5;
        }

        #alarmList .badge {
            font-size: 0.75rem;
            padding: 3px 8px;
            border-radius: 10px;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100px;
        }

        #alarmList .badge-form-annual { background-color: #28a745; color: #fff; }
        #alarmList .badge-form-project { background-color: #17a2b8; color: #fff; }
        #alarmList .badge-form-expense { background-color: #dc3545; color: #fff; }
        #alarmList .badge-form-resign { background-color: #6c757d; color: #fff; }
        #alarmList .badge-form-unknown { background-color: #343a40; color: #fff; }
        #alarmList .badge-title { background-color: #6c757d; color: #fff; max-width: 120px; }
        #alarmList .badge-writer { background-color: #007bff; color: #fff; }
    </style>

    <sitemesh:write property="head"/>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid p-2">
        <a class="navbar-brand" href="/"><i class="fa-solid fa-cubes"></i> LDBSOFT Groupware</a>
        <div class="d-flex">
            <div class="dropdown me-3 dropstart">
                <button class="btn" id="searchToggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
                <ul class="dropdown-menu p-3 search-dropdown">
                    <form class="mb-2">
                        <input type="text" id="searchInput" class="form-control" placeholder="사원 이름 검색"
                               autocomplete="off">
                    </form>
                    <div id="searchResults"></div>
                </ul>
            </div>
            <div class="dropdown me-3">
                <a class="btn position-relative" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-bell"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" id="alarmList">
                    <%-- 알람리스트 동적 생성 --%>
                </ul>
            </div>
            <span class="me-3 text-dark"><i class="fa-solid fa-user-circle"></i> ${sessionScope.loginId} 님</span>
            <a href="/login/doLogout" class="btn btn-outline-danger btn-sm">로그아웃</a>
        </div>
    </div>
</nav>
<div class="content-wrapper">
    <div class="col-md-2 sidebar p-0">
        <ul class="nav flex-column nav-pills" id="sidebarMenu">
            <!-- 홈 -->
            <c:if test="${fn:contains(allowedMenus, 'A_0000') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" href="/">
                        <i class="fa-solid fa-house"></i> 홈
                    </a>
                </li>
            </c:if>
            <!-- 개인정보 -->
            <c:if test="${fn:contains(allowedMenus, 'A_0001') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" href="/member/getMemberInfo">
                        <i class="fa-solid fa-user"></i> 개인정보
                    </a>
                </li>
            </c:if>
            <!-- ================= 게시판 ================= -->
            <c:if test="${fn:contains(allowedMenus, 'A_0002') || fn:contains(allowedMenus, 'A_0004') || fn:contains(allowedMenus, 'A_0005') || fn:contains(allowedMenus, 'A_0006') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#boardMenu" role="button" aria-expanded="false"
                       aria-controls="boardMenu">
                        <i class="fa-solid fa-thumbtack me-1"></i> 게시판 ▾
                    </a>
                    <div class="collapse" id="boardMenu">
                        <ul class="nav flex-column ms-3">
                            <c:if test="${fn:contains(allowedMenus, 'A_0002') || fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/board/getNoticeList">공지사항</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0004') || fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/board/getFaqList">자주묻는질문</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0005') || fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/board/getQnaList">질문게시판</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0006') || fn:startsWith(sessionScope.loginId,'admin') }">
                                <li class="nav-item"><a class="nav-link" href="/board/getFaqListManage">자주묻는질문 관리</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </li>
            </c:if>
            <!-- ================= 전자결재 ================= -->
            <c:if test="${fn:contains(allowedMenus, 'A_0007') || fn:contains(allowedMenus, 'A_0008') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#draftMenu" role="button" aria-expanded="false"
                       aria-controls="draftMenu">
                        <i class="fa-solid fa-file-signature me-1"></i> 전자결재 ▾
                    </a>
                    <div class="collapse" id="draftMenu">
                        <ul class="nav flex-column ms-3">
                            <c:if test="${fn:contains(allowedMenus, 'A_0007')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/draft/getMyDraftList">내 전자결재</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0008')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/draft/receivedDraftList">받은 전자결재</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </li>
            </c:if>
            <!-- ================= 공용설비 ================= -->
            <c:if test="${fn:contains(allowedMenus, 'A_0009') || fn:contains(allowedMenus, 'A_0010')
            || fn:contains(allowedMenus, 'A_0011') || fn:contains(allowedMenus, 'A_0012') || fn:contains(allowedMenus, 'A_0013')
            || fn:contains(allowedMenus, 'A_0014') || fn:contains(allowedMenus, 'A_0015') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#facilityMenu" role="button"
                       aria-expanded="false" aria-controls="facilityMenu">
                        <i class="fa-solid fa-building me-1"></i> 공용설비 ▾
                    </a>
                    <div class="collapse" id="facilityMenu">
                        <ul class="nav flex-column ms-3">
                            <c:if test="${fn:contains(allowedMenus, 'A_0009')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getVehicleList">차량예약</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0010')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getMeetingRoomList">회의실예약</a>
                                </li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0011')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getItemList">비품예약</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0012')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getReservationList">내 예약내역</a>
                                </li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0013')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getVehicleManage">차량관리</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0014')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getMeetingRoomManage">회의실관리</a>
                                </li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0015')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/facility/getItemManage">비품관리</a></li>
                            </c:if>
                        </ul>
                    </div>
                </li>
            </c:if>
            <!-- ================= 일정 ================= -->
            <c:if test="${fn:contains(allowedMenus, 'A_0016') || fn:contains(allowedMenus, 'A_0017') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#calendarMenu" role="button"
                       aria-expanded="false" aria-controls="calendarMenu">
                        <i class="fa-solid fa-calendar-days me-1"></i> 일정 ▾
                    </a>
                    <div class="collapse" id="calendarMenu">
                        <ul class="nav flex-column ms-3">
                            <c:if test="${fn:contains(allowedMenus, 'A_0016')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/calendar/getCalendar">캘린더</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0017')|| fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/calendar/getCalendarList">일정관리</a></li>
                            </c:if>
                        </ul>
                    </div>
                </li>
            </c:if>
            <!-- ================= 관리자 메뉴 ================= -->
            <c:if test="${fn:contains(allowedMenus, 'A_0018') || fn:contains(allowedMenus, 'A_0020') || fn:startsWith(sessionScope.loginId,'admin')}">
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#adminMenu" role="button" aria-expanded="false"
                       aria-controls="adminMenu">
                        <i class="fa-solid fa-cogs me-1"></i> 관리자 ▾
                    </a>
                    <div class="collapse" id="adminMenu">
                        <ul class="nav flex-column ms-3">
                            <c:if test="${fn:contains(allowedMenus, 'A_0018') || fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/admin/getMemberList">사원관리</a></li>
                            </c:if>
                            <c:if test="${fn:startsWith(sessionScope.loginId,'admin') }">
                                <li class="nav-item"><a class="nav-link" href="/admin/getDeptAuthList">부서권한관리</a></li>
                            </c:if>
                            <c:if test="${fn:contains(allowedMenus, 'A_0020') || fn:startsWith(sessionScope.loginId,'admin')}">
                                <li class="nav-item"><a class="nav-link" href="/admin/dashBoard">연차사용률 조회</a></li>
                            </c:if>
                            <c:if test="${fn:startsWith(sessionScope.loginId,'admin') }">
                                <li class="nav-item"><a class="nav-link" href="/admin/getCommType">공통 코드 관리</a></li>
                            </c:if>
                        </ul>
                    </div>
                </li>
            </c:if>
        </ul>
    </div>

    <div class="page-container">
        <sitemesh:write property="body"/>
    </div>

</div>
<div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="employeeModalLabel">사원 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body" id="employeeModalBody"></div>
        </div>
    </div>
</div>
<script>
    function showAlarm() {
        $.ajax({
            url: "/alarm/getAlarmList",
            type: "GET",
            dataType: "json",
            success: function (res) {
                var alarms = res.data || [];
                var alarmList = $("#alarmList");
                alarmList.empty();

                if (alarms.length === 0) {
                    alarmList.append('<li class="dropdown-item text-muted">새 알람이 없습니다.</li>');
                } else {
                    for (var i = 0; i < alarms.length; i++) {
                        var alarm = alarms[i];
                        var formCodeStr = alarm.formCodeToStr || "양식정보없음";
                        var statusNum = getStatusBadge(alarm.status) || "미지정";
                        var docTitle = alarm.docTitle || "제목 없음";
                        var writer = alarm.writer || "작성자 없음";
                        var url = alarm.url || "#";
                        var docId = alarm.docId || "";
                        var stepOrder = alarm.stepOrder || "";

                        // formCodeStr에 따라 다른 클래스 적용
                        var formClass;
                        switch (formCodeStr) {
                            case "휴가":
                                formClass = "badge-form-annual";
                                break;
                            case "프로젝트":
                                formClass = "badge-form-project";
                                break;
                            case "지출":
                                formClass = "badge-form-expense";
                                break;
                            case "사직":
                                formClass = "badge-form-resign";
                                break;
                            default:
                                formClass = "badge-form-unknown";
                        }

                        // 각 요소를 배지 스타일로 감싸기
                        var alarmHtml = '<li>' +
                            '<a class="dropdown-item alarm-link" href="' + url +
                            '" data-docid="' + docId + '" data-statusnum="' + alarm.status + '" data-formcode="' + alarm.formCode + '">' +
                            '<span class="badge ' + formClass + '">[' + formCodeStr + ']</span>' +
                            '<span class="badge badge-title">제목: ' + docTitle + '</span>' +
                            statusNum +
                            '<span class="badge badge-writer">작성자: ' + writer + '</span>' +
                            '</a></li>';

                        alarmList.append(alarmHtml);
                    }
                }

                // 클릭 이벤트 핸들러
                $(".alarm-link").click(function (e) {
                    e.preventDefault();
                    var link = $(this);
                    var baseUrl = link.attr("href");
                    var docId = link.data("docid");
                    var statusNum = link.data("statusnum");
                    var formCode = link.data("formcode");

                    alarmParams = {
                        docId: docId,
                        memId: '${sessionScope.loginId}',
                        readYn: 'Y',
                    };
                    // 알람 읽음처리
                    $.ajax({
                        url: "/alarm/markAsRead",
                        type: "POST",
                        data: alarmParams,
                        async: false // 읽음 처리 후 이동
                    });

                    // 쿼리 파라미터 동적으로 추가
                    var params = {};
                    if (docId) {
                        params.docId = docId;
                    }
                    if (statusNum) {
                        params.status = statusNum;
                    }
                    if (formCode) {
                        params.formCode = formCode;
                    }

                    var finalUrl = baseUrl;
                    if (Object.keys(params).length > 0) {
                        var queryString = $.param(params);
                        finalUrl += (baseUrl.indexOf("?") === -1 ? "?" : "&") + queryString;
                    }

                    window.location.href = finalUrl;
                });

                // 알람 개수 업데이트
                var badge = $(".badge.rounded-pill.bg-danger");
                badge.text(alarms.length);
                if (alarms.length === 0) {
                    badge.hide();
                } else {
                    badge.show();
                }
            },
            error: function (xhr) {
                console.error("알람정보 불러오기 실패", xhr.responseText);
                $("#alarmList").empty().append('<li class="dropdown-item text-muted">알람을 불러오지 못했습니다.</li>');
            }
        });
    }

    function getStatusBadge(status) {
        if (status == "0") {
            return "<span class='badge bg-secondary'>임시저장</span>";
        } else if (status == "1") {
            return "<span class='badge bg-warning text-dark'>1차결재 대기</span>";
        } else if (status == "2") {
            return "<span class='badge bg-warning text-dark'>1차결재 승인</span>";
        } else if (status == "3") {
            return "<span class='badge bg-danger'>1차결재 반려</span>";
        } else if (status == "4") {
            return "<span class='badge bg-info text-dark'>2차결재 대기</span>";
        } else if (status == "5") {
            return "<span class='badge bg-success'>2차결재 승인</span>";
        } else if (status == "6") {
            return "<span class='badge bg-danger'>2차결재 반려</span>";
        } else {
            return "<span class='badge bg-dark'>알 수 없음</span>";
        }
    }

    let employees = [];

    document.getElementById("searchToggle").addEventListener("click", function (e) {
        if (employees.length > 0) {
            return;
        }

        $.ajax({
            url: "/member/memberlist",
            type: "GET",
            dataType: "json",
            success: function (res) {
                employees = res.data;
            },
            error: function (xhr, status, error) {
                console.error("사원정보 불러오기 실패", error);
            }
        });
    });

    document.getElementById("searchInput").addEventListener("input", function () {
        const keyword = this.value.trim();
        const results = document.getElementById("searchResults");
        results.innerHTML = "";
        if (keyword.length === 0) return;

        const kw = keyword.toLowerCase();
        const filtered = employees.filter(emp =>
            emp.memName.includes(kw) ||
            emp.deptName.includes(kw) ||
            emp.memEmail.toLowerCase().includes(kw));
        if (filtered.length === 0) {
            results.innerHTML = "<div class='text-muted px-2'><i class='fa-regular fa-face-frown'></i> 검색 결과 없음</div>";
            return;
        }
        filtered.forEach(emp => {
            const item = document.createElement("li");
            item.classList.add("dropdown-item");
            item.innerHTML = "<i class='fa-solid fa-user'></i> " + emp.memName + " (" + emp.deptName + ")";
            item.style.cursor = "pointer";
            item.addEventListener("click", () => {
                document.getElementById("employeeModalBody").innerHTML =
                    "<ul class='list-group'>" +
                    "<li class='list-group-item'><i class='fa-solid fa-user'></i> <strong>이름:</strong> " + emp.memName + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-building'></i> <strong>부서:</strong> " + emp.deptName + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-layer-group'></i> <strong>직급:</strong> " + emp.rankName + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-envelope'></i> <strong>이메일:</strong> " + emp.memEmail + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-phone'></i> <strong>연락처:</strong> " + emp.memPhone + "</li>" +
                    "</ul>";
                new bootstrap.Modal(document.getElementById("employeeModal")).show();
            });
            results.appendChild(item);
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const sidebarLinks = document.querySelectorAll('#sidebarMenu .nav-link');
        const currentPath = window.location.pathname;

        sidebarLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href && currentPath === href) {
                link.classList.add('active');
                const parentCollapse = link.closest('.collapse');
                if (parentCollapse) {
                    const parentLink = parentCollapse.previousElementSibling;
                    if (parentLink && parentLink.classList.contains('nav-link')) {
                        parentLink.classList.remove('active');
                    }
                }
            }

            link.addEventListener('click', function (e) {
                sidebarLinks.forEach(l => l.classList.remove('active'));
                if (href && currentPath === href) {
                    this.classList.add('active');
                    const parentCollapse = this.closest('.collapse');
                    if (parentCollapse) {
                        const parentLink = parentCollapse.previousElementSibling;
                        if (parentLink && parentLink.classList.contains('nav-link')) {
                            parentLink.classList.remove('active');
                        }
                    }
                }

                if (this.nextElementSibling && this.nextElementSibling.classList.contains('collapse')) {
                    const subLinks = this.nextElementSibling.querySelectorAll('.nav-link');
                    subLinks.forEach(subLink => {
                        if (subLink.getAttribute('href') === currentPath) {
                            subLink.classList.add('active');
                            this.classList.remove('active');
                        }
                    });
                }
            });
        });

        sidebarLinks.forEach(link => {
            if (link.nextElementSibling && link.nextElementSibling.classList.contains('collapse')) {
                const subLinks = link.nextElementSibling.querySelectorAll('.nav-link');
                subLinks.forEach(subLink => {
                    if (subLink.getAttribute('href') === currentPath) {
                        subLink.classList.add('active');
                        link.setAttribute('aria-expanded', 'true');
                        link.nextElementSibling.classList.add('show');
                    }
                });
            }
        });
    });

    const timeoutSec = 10800;
    const warnSec = timeoutSec - 300;

    setTimeout(() => {
        alert("세션이 5분 후에 만료됩니다.");
    }, warnSec * 1000);

    setTimeout(() => {
        alert("세션이 만료되어 자동 로그아웃됩니다.");
        location.href = "/login/doLogout";
    }, timeoutSec * 1000);

    $(document).ready(function () {
        showAlarm();
    });
</script>
</body>
</html>