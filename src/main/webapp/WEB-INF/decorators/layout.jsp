<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><sitemesh:write property="title"/></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            background: url('/img/won2.jpg') center center / cover no-repeat fixed;
        }

        .bg-glass, .card, .list-group-item {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border-radius: 0.75rem;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .navbar-brand {
            font-weight: bold;
            color: #0d6efd !important;
        }

        .sidebar {
            height: calc(100vh - 90px);
            padding-top: 20px;
        }

        .nav-pills .nav-link.active {
            background-color: #0d6efd;
        }

        .glass-content {
            padding: 20px;
            height: 100%;
        }

        .modal-content {
            border-radius: 1rem;
        }

        .dropdown-menu {
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: none;
            -webkit-backdrop-filter: none;
        }

        .content-wrapper {
            display: flex;
            min-height: calc(100vh - 100px);
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-glass shadow-sm m-2 px-3">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="fa-solid fa-cubes"></i> LDBSOFT Groupware</a>
        <div class="d-flex">
            <div class="dropdown me-3">
                <button class="btn" id="searchToggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
                <ul class="dropdown-menu p-3" style="min-width: 300px;">
                    <form class="mb-2">
                        <input type="text" id="searchInput" class="form-control" placeholder="사원 이름 검색" autocomplete="off">
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

            <span class="me-3 text-dark"><i class="fa-solid fa-user-circle"></i>${sessionScope.loginId} 님</span>
            <a href="/login/doLogout" class="btn btn-outline-danger btn-sm">로그아웃</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-3">
    <div class="content-wrapper">
        <div class="col-md-2 bg-glass me-2 sidebar">
            <ul class="nav flex-column nav-pills" id="sidebarMenu">
                <li class="nav-item"><a class="nav-link" href="/"><i class="fa-solid fa-house"></i> 홈</a></li>
                <li class="nav-item"><a class="nav-link" href="/member/getMemberInfo"><i class="fa-solid fa-user"></i> 개인정보</a></li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#boardMenu" role="button" aria-expanded="false" aria-controls="boardMenu">
                        <i class="fa-solid fa-thumbtack me-1"></i> 게시판 ▾
                    </a>
                    <div class="collapse ps-3" id="boardMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/board/getNoticeList"><i class="fa-solid fa-bullhorn"></i> 공지사항</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/getFaqList"><i class="fa-solid fa-question"></i> 자주묻는질문</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/getQnaList"><i class="fa-solid fa-comments"></i> 질문게시판</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/getFaqListManage"><i class="fa-solid fa-tools"></i> 자주묻는질문 관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#draftMenu" role="button" aria-expanded="false" aria-controls="draftMenu">
                        <i class="fa-solid fa-pen-nib me-1"></i> 전자결재 ▾
                    </a>
                    <div class="collapse ps-3" id="draftMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/draft/getMyDraftList"><i class="fa-solid fa-file-signature"></i> 내 전자결재</a></li>
                            <li class="nav-item"><a class="nav-link" href="/draft/receivedDraftList"><i class="fa-solid fa-inbox"></i> 받은 전자결재</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#facilityMenu" role="button" aria-expanded="false" aria-controls="facilityMenu">
                        <i class="fa-solid fa-cogs me-1"></i> 공용설비 ▾
                    </a>
                    <div class="collapse ps-3" id="facilityMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/facility/getVehicleList">차량예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/getMeetingRoomList"><i class="fa-solid fa-door-open"></i> 회의실예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/getItemList"><i class="fa-solid fa-box"></i> 비품예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/getReservationList"><i class="fa-solid fa-list"></i> 내 예약내역</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/roomManage"><i class="fa-solid fa-car-side"></i> 차량관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/meetingRoomManage"><i class="fa-solid fa-building"></i> 회의실관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/facility/itemListManage"><i class="fa-solid fa-tools"></i> 비품관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#calendarMenu" role="button" aria-expanded="false" aria-controls="calendarMenu">
                        <i class="fa-solid fa-calendar-days"></i> 캘린더 ▾
                    </a>
                    <div class="collapse ps-3" id="calendarMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/calendar/getCalendar"><i class="fa-regular fa-calendar-check me-1"></i>
                                캘린더</a></li>
                            <li class="nav-item"><a class="nav-link" href="/calendar/getCalendarList"><i class="fa-solid fa-sliders me-1"></i> 일정관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#adminMenu" role="button" aria-expanded="false" aria-controls="adminMenu">
                        <i class="fa-solid fa-user-gear me-1"></i> 관리자 ▾
                    </a>
                    <div class="collapse ps-3" id="adminMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/admin/getMemberList"><i class="fa-solid fa-users"></i> 사원관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/deptAuth"><i class="fa-solid fa-shield-alt"></i> 부서권한관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/dashBoard"><i class="fa-solid fa-chart-pie"></i> 연차사용률</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>

        <div class="flex-fill">
            <div class="glass-content">
                <sitemesh:write property="body"/>
            </div>
        </div>
    </div>
</div>

<!-- 모달 -->
<div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content bg-glass">
            <div class="modal-header">
                <h5 class="modal-title" id="employeeModalLabel">사원 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body" id="employeeModalBody"></div>
        </div>
    </div>
</div>

<script>
    const employees = [
        {name: "김사원", dept: "개발팀", rank: "사원", email: "kim@ldbsoft.co.kr", phone: "010-1234-0001"},
        {name: "이대리", dept: "영업팀", rank: "대리", email: "lee@ldbsoft.co.kr", phone: "010-5678-0002"},
        {name: "박과장", dept: "기획팀", rank: "과장", email: "park@ldbsoft.co.kr", phone: "010-1111-0003"}
    ];

    document.getElementById("searchInput").addEventListener("input", function () {
        const keyword = this.value.trim();
        const results = document.getElementById("searchResults");
        results.innerHTML = "";
        if (keyword.length === 0) return;

        const filtered = employees.filter(emp => emp.name.includes(keyword));
        if (filtered.length === 0) {
            results.innerHTML = "<div class='text-muted px-2'><i class='fa-regular fa-face-frown'></i> 검색 결과 없음</div>";
            return;
        }

        filtered.forEach(emp => {
            const item = document.createElement("li");
            item.classList.add("dropdown-item");
            item.innerHTML = "<i class='fa-solid fa-user'></i> " + emp.name + " (" + emp.dept + ")";
            item.style.cursor = "pointer";
            item.addEventListener("click", () => {
                document.getElementById("employeeModalBody").innerHTML =
                    "<ul class='list-group'>" +
                    "<li class='list-group-item'><i class='fa-solid fa-user'></i> <strong>이름:</strong> " + emp.name + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-building'></i> <strong>부서:</strong> " + emp.dept + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-layer-group'></i> <strong>직급:</strong> " + emp.rank + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-envelope'></i> <strong>이메일:</strong> " + emp.email + "</li>" +
                    "<li class='list-group-item'><i class='fa-solid fa-phone'></i> <strong>연락처:</strong> " + emp.phone + "</li>" +
                    "</ul>";
                new bootstrap.Modal(document.getElementById("employeeModal")).show();
            });
            results.appendChild(item);
        });
    });

    // 사이드바 메뉴 활성화 처리
    document.addEventListener("DOMContentLoaded", function() {
        const sidebarLinks = document.querySelectorAll('#sidebarMenu .nav-link');
        const currentPath = window.location.pathname;

        sidebarLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href && currentPath === href) {
                // 하위 링크가 활성화된 경우, 상위 메뉴는 비활성화
                link.classList.add('active');
                const parentCollapse = link.closest('.collapse');
                if (parentCollapse) {
                    const parentLink = parentCollapse.previousElementSibling;
                    if (parentLink && parentLink.classList.contains('nav-link')) {
                        parentLink.classList.remove('active');
                    }
                }
            }

            link.addEventListener('click', function(e) {
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

                // Collapse 메뉴 내 클릭 시 처리
                if (this.nextElementSibling && this.nextElementSibling.classList.contains('collapse')) {
                    const subLinks = this.nextElementSibling.querySelectorAll('.nav-link');
                    subLinks.forEach(subLink => {
                        if (subLink.getAttribute('href') === currentPath) {
                            subLink.classList.add('active');
                            this.classList.remove('active'); // 상위 메뉴 비활성화
                        }
                    });
                }
            });
        });

        // 초기 로드 시 collapse 상태 유지
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
    const warnSec = timeoutSec - 300; // 세션 남은 시간 5분전

    // 세션 5분전 알림
    setTimeout(() => {
        alert("세션이 5분 후에 만료됩니다.");
    }, warnSec * 1000);

    // 세션 만료 시 로그 아웃
    setTimeout(() => {
        alert("세션이 만료되어 자동 로그아웃됩니다.");
        location.href = "/login/doLogout";
    }, timeoutSec * 1000);
</script>
</body>
</html>