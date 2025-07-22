<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
            <ul class="nav flex-column nav-pills">
                <li class="nav-item"><a class="nav-link active" href="/"><i class="fa-solid fa-house"></i> 홈</a></li>
                <li class="nav-item"><a class="nav-link" href="/member/memberInfo"><i class="fa-solid fa-user"></i> 개인정보</a></li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#boardMenu" role="button" aria-expanded="false" aria-controls="boardMenu">
                        <i class="fa-solid fa-thumbtack me-1"></i> 게시판 ▾
                    </a>
                    <div class="collapse ps-3" id="boardMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/board/getNoticeList">공지사항</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/getFaqList">자주묻는질문</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/questionList">질문게시판</a></li>
                            <li class="nav-item"><a class="nav-link" href="/board/getFaqListManage">자주묻는질문 관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#draftMenu" role="button" aria-expanded="false" aria-controls="draftMenu">
                        <i class="fa-solid fa-pen-nib me-1"></i> 전자결재 ▾
                    </a>
                    <div class="collapse ps-3" id="draftMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/draft/getMyDraftList">내 전자결재</a></li>
                            <li class="nav-item"><a class="nav-link" href="/draft/receivedDraftList">받은 전자결재</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#facilityMenu" role="button" aria-expanded="false" aria-controls="facilityMenu">
                        <i class="fa-solid fa-cogs me-1"></i> 공용설비 ▾
                    </a>
                    <div class="collapse ps-3" id="facilityMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/reservation/vehicleList">차량예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/reservation/meetingRoomList">회의실예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/reservation/itemList">비품예약</a></li>
                            <li class="nav-item"><a class="nav-link" href="/reservation/reservationList">내 예약내역</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/vehicleManage">차량관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/meetingRoomManage">회의실관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/itemListManage">비품관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#calendarMenu" role="button" aria-expanded="false" aria-controls="calendarMenu">
                        <i class="fa-solid fa-calendar-days"></i> 캘린더 ▾
                    </a>
                    <div class="collapse ps-3" id="calendarMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/calendar/calendar"><i class="fa-regular fa-calendar-check me-1"></i> 내 캘린더</a></li>
                            <li class="nav-item"><a class="nav-link" href="/calendar/calendarList"><i class="fa-solid fa-sliders me-1"></i> 일정관리</a></li>
                        </ul>
                    </div>
                </li>
                <li class="nav-item"><a class="nav-link" href="/email"><i class="fa-solid fa-envelope"></i> 이메일</a></li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="collapse" href="#adminMenu" role="button" aria-expanded="false" aria-controls="adminMenu">
                        <i class="fa-solid fa-user-gear me-1"></i> 관리자 ▾
                    </a>
                    <div class="collapse ps-3" id="adminMenu">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="/admin/memberList">사원관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/deptAuth">부서권한관리</a></li>
                            <li class="nav-item"><a class="nav-link" href="/admin/dashBoard">연차사용률</a></li>
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

    const timeoutSec = 10800;
    const warnSec = timeoutSec - 300; // 세션 남은 시간 5분전

    // 세선 5분전 알림
    setTimeout(() =>{
        alert("세션이 5분 후에 만료 됩니다.");
    }, warnSec * 1000);

    // 세션 만료 시 로그 아웃
    setTimeout(() => {
        alert("세션이 만료되어 자동 로그아웃됩니다.");
        location.href ="/login/doLogout";
    }, timeoutSec * 1000);

</script>
</body>
</html>
