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
            min-height: 100%;
            background-color: #f8f9fa;
        }

        .navbar {
            background-color: #ffffff;
        }

        .navbar-brand {
            font-weight: bold;
            color: #0d6efd !important;
        }

        .sidebar {
            height: calc(100vh - 90px);
            padding-top: 20px;
            background-color: #ffffff;
            border-end: 1px solid #dee2e6;
        }

        .nav-pills .nav-link {
            color: #212529;
        }

        .nav-pills .nav-link.active {
            background-color: #0d6efd;
            color: #ffffff;
        }

        .nav-pills .nav-link:hover {
            background-color: #e9ecef;
        }

        .content-wrapper {
            display: flex;
            min-height: calc(100vh - 100px);
        }

        .glass-content {
            padding: 20px;
            background-color: #ffffff;
            border-radius: 0.375rem;
        }

        .modal-content {
            background-color: #ffffff;
            border-radius: 0.375rem;
        }

        .dropdown-menu {
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .search-dropdown {
            min-width: 300px;
            transform: translateY(45px);
        }

        .list-group-item {
            background-color: #ffffff;
            border: 1px solid #dee2e6;
        }

        .form-control {
            border-radius: 0.375rem;
        }

        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light shadow-sm m-2 px-3">
    <div class="container-fluid">
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
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">3</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#">[공지] 서버 점검 안내</a></li>
                    <li><a class="dropdown-item" href="#">결제 요청이 있습니다</a></li>
                    <li><a class="dropdown-item" href="#">새 공지사항 등록</a></li>
                </ul>
            </div>

            <span class="me-3 text-dark"><i class="fa-solid fa-user-circle"></i> ${sessionScope.loginId} 님</span>
            <a href="/login/doLogout" class="btn btn-outline-danger btn-sm">로그아웃</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-3">
    <div class="content-wrapper">
        <div class="col-md-2 bg-glass me-2 sidebar">
            <ul class="nav flex-column nav-pills" id="sidebarMenu">

                <!-- 홈 -->
                <li class="nav-item">
                    <a class="nav-link" href="/">
                        <i class="fa-solid fa-house"></i> 홈
                    </a>
                </li>

                <!-- 개인정보 -->
                <c:if test="${fn:contains(allowedMenus, 'MEMBER_INFO')}">
                    <li class="nav-item">
                        <a class="nav-link" href="/member/getMemberInfo">
                            <i class="fa-solid fa-user"></i> 개인정보
                        </a>
                    </li>
                </c:if>

                <!-- ================= 게시판 ================= -->
                <c:if test="${fn:contains(allowedMenus, 'BOARD_NOTICE')
                     || fn:contains(allowedMenus, 'BOARD_FAQ')
                     || fn:contains(allowedMenus, 'BOARD_QNA')
                     || fn:contains(allowedMenus, 'BOARD_FAQ_MANAGE')}">

                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#boardMenu" role="button"
                           aria-expanded="false" aria-controls="boardMenu">
                            <i class="fa-solid fa-thumbtack me-1"></i> 게시판 ▾
                        </a>
                        <div class="collapse" id="boardMenu">
                            <ul class="nav flex-column ms-3">
                                <c:if test="${fn:contains(allowedMenus, 'BOARD_NOTICE')}">
                                    <li class="nav-item"><a class="nav-link" href="/board/getNoticeList">공지사항</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'BOARD_FAQ')}">
                                    <li class="nav-item"><a class="nav-link" href="/board/getFaqList">자주묻는질문</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'BOARD_QNA')}">
                                    <li class="nav-item"><a class="nav-link" href="/board/getQnaList">질문게시판</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'BOARD_FAQ_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link" href="/board/getFaqListManage">FAQ 관리</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </c:if>

                <!-- ================= 전자결재 ================= -->
                <c:if test="${fn:contains(allowedMenus, 'DRAFT_MY')
                     || fn:contains(allowedMenus, 'DRAFT_RECEIVED')}">

                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#draftMenu" role="button"
                           aria-expanded="false" aria-controls="draftMenu">
                            <i class="fa-solid fa-file-signature me-1"></i> 전자결재 ▾
                        </a>
                        <div class="collapse" id="draftMenu">
                            <ul class="nav flex-column ms-3">
                                <c:if test="${fn:contains(allowedMenus, 'DRAFT_MY')}">
                                    <li class="nav-item"><a class="nav-link" href="/draft/getMyDraftList">내 전자결재</a>
                                    </li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'DRAFT_RECEIVED')}">
                                    <li class="nav-item"><a class="nav-link" href="/draft/receivedDraftList">받은 전자결재</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </c:if>

                <!-- ================= 공용설비 ================= -->
                <c:if test="${fn:contains(allowedMenus, 'FACILITY_VEHICLE')
                     || fn:contains(allowedMenus, 'FACILITY_MEETING_ROOM')
                     || fn:contains(allowedMenus, 'FACILITY_ITEM')
                     || fn:contains(allowedMenus, 'FACILITY_MY_RESERVATION')
                     || fn:contains(allowedMenus, 'FACILITY_VEHICLE_MANAGE')
                     || fn:contains(allowedMenus, 'FACILITY_MEETING_ROOM_MANAGE')
                     || fn:contains(allowedMenus, 'FACILITY_ITEM_MANAGE')}">

                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#facilityMenu" role="button"
                           aria-expanded="false" aria-controls="facilityMenu">
                            <i class="fa-solid fa-building me-1"></i> 공용설비 ▾
                        </a>
                        <div class="collapse" id="facilityMenu">
                            <ul class="nav flex-column ms-3">
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_VEHICLE')}">
                                    <li class="nav-item"><a class="nav-link" href="/facility/getVehicleList">차량예약</a>
                                    </li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_MEETING_ROOM')}">
                                    <li class="nav-item"><a class="nav-link"
                                                            href="/facility/getMeetingRoomList">회의실예약</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_ITEM')}">
                                    <li class="nav-item"><a class="nav-link" href="/facility/getItemList">비품예약</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_MY_RESERVATION')}">
                                    <li class="nav-item"><a class="nav-link" href="/facility/getReservationList">내
                                        예약내역</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_VEHICLE_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link" href="/facility/getVehicleManage">차량관리</a>
                                    </li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_MEETING_ROOM_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link"
                                                            href="/facility/getMeetingRoomManage">회의실관리</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'FACILITY_ITEM_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link" href="/facility/getItemManage">비품관리</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </c:if>

                <!-- ================= 일정 ================= -->
                <c:if test="${fn:contains(allowedMenus, 'CALENDAR_VIEW')
                     || fn:contains(allowedMenus, 'CALENDAR_MANAGE')}">

                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#calendarMenu" role="button"
                           aria-expanded="false" aria-controls="calendarMenu">
                            <i class="fa-solid fa-calendar-days me-1"></i> 일정 ▾
                        </a>
                        <div class="collapse" id="calendarMenu">
                            <ul class="nav flex-column ms-3">
                                <c:if test="${fn:contains(allowedMenus, 'CALENDAR_VIEW')}">
                                    <li class="nav-item"><a class="nav-link" href="/calendar/getCalendar">캘린더</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'CALENDAR_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link" href="/calendar/getCalendarList">일정관리</a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </c:if>

                <!-- ================= 관리자 메뉴 ================= -->
                <c:if test="${fn:contains(allowedMenus, 'MEMBER_MANAGE')
                     || fn:contains(allowedMenus, 'DEPT_AUTH')
                     || fn:contains(allowedMenus, 'ANNUAL_USAGE_RATE')}">

                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="collapse" href="#adminMenu" role="button"
                           aria-expanded="false" aria-controls="adminMenu">
                            <i class="fa-solid fa-cogs me-1"></i> 관리자 ▾
                        </a>
                        <div class="collapse" id="adminMenu">
                            <ul class="nav flex-column ms-3">
                                <c:if test="${fn:contains(allowedMenus, 'MEMBER_MANAGE')}">
                                    <li class="nav-item"><a class="nav-link" href="/admin/getMemberList">사원관리</a></li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'DEPT_AUTH')}">
                                    <li class="nav-item"><a class="nav-link" href="/admin/getDeptAuthList">부서권한관리</a>
                                    </li>
                                </c:if>
                                <c:if test="${fn:contains(allowedMenus, 'ANNUAL_USAGE_RATE')}">
                                    <li class="nav-item"><a class="nav-link" href="/admin/dashBoard">연차사용률 조회</a></li>
                                </c:if>
                            </ul>
                        </div>
                    </li>
                </c:if>

            </ul>
        </div>

        <div class="flex-fill">
            <div class="glass-content">
                <sitemesh:write property="body"/>
            </div>
        </div>
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
</script>
</body>
</html>