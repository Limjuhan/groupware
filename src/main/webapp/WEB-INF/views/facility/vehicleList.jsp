<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>차량예약리스트 - LDBSOFT 그룹웨어</title>
    <style>
        body {
            background-color: #f4f6f9;
        }

        .container {
            max-width: 1200px;
            margin-top: 40px;
        }

        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">🚗 차량예약리스트</h2>

    <!-- 검색 및 필터 폼 -->
    <form class="row g-2 align-items-center mb-4" method="get" action="getVehicleList">
        <!-- 비품명 검색 -->
        <div class="col-md-5">
            <div class="form-floating">
                <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: G70">
                <label for="keyword">차량명/공용설비ID</label>
            </div>
        </div>

        <!-- 반납 여부 -->
        <div class="col-md-3">
            <div class="form-floating">
                <select name="rentYn" id="rentYn" class="form-select">
                    <option value="">전체</option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
                <label for="rentYn">반납여부</label>
            </div>
        </div>

        <!-- 검색 버튼 -->
        <div class="col-md-2 d-grid">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
            </button>
        </div>
    </form>

    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>차량명</th>
            <th>식별번호</th>
            <th>수용인원</th>
            <th>반납여부</th>
            <th>예약</th>
        </tr>
        </thead>
        <tbody>
        <!-- 차량목록 하드코딩 -->

        <c:forEach items="${facility}" var="room">
            <tr>
                <td>${room.facId}</td>
                <td>${room.facName}</td>
                <td>${room.facUid}</td>
                <td>${room.capacity}</td>
                <td>${room.rentYn}</td>
                <c:if test="${room.rentYn eq 'Y'}">
                    <td>
                        <button class="btn btn-outline-primary btn-sm"
                                onclick="openModal('${room.facId}', '${room.facName}')">예약하기
                        </button>
                    </td>
                </c:if>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item">
                <a class="page-link" href="?page=${pageDto.page - 1}">이전</a>
            </li>
            <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="p">
                <li class="page-item ">
                    <a class="page-link" href="?page=${p}">${p}</a>
                </li>
            </c:forEach>
            <li class="page-item">
                <a class="page-link" href="?page=${pageDto.page+1}">다음</a>
            </li>
        </ul>
    </nav>
</div>

<div class="modal fade" id="reserveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">차량 예약</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="reserveForm" action="insertFacilityRent" method="post">
                    <input type="hidden" name="startAt" id="startAt">
                    <input type="hidden" name="endAt" id="endAt">
                    <input type="hidden" name="rentalPurpose" id="rentalPurpose">
                    <input type="hidden" name="facId" id="facId">
                    <input type="hidden" name="renterId" value="${sessionScope.loginId}"> <%-- 세션으로변경해야함--%>
                </form>

                <p id="reserveInfo"></p>
                <!-- 시작일 -->
                <label class="form-label">시작일</label>
                <input type="date" class="form-control mb-2" id="carStartDate">

                <!-- 시작시간 (직접입력) -->
                <label class="form-label">시작시간 (0~23)</label>
                <input type="number" class="form-control mb-3" id="carStartHour" min="0" max="23" placeholder="예: 9">

                <!-- 종료일 -->
                <label class="form-label">종료일</label>
                <input type="date" class="form-control mb-2" id="carEndDate">

                <!-- 종료시간 (직접입력) -->
                <label class="form-label">종료시간 (0~23)</label>
                <input type="number" class="form-control mb-3" id="carEndHour" min="0" max="23" placeholder="예: 18">

                <!-- 대여 목적 -->
                <label class="form-label">대여 목적</label>
                <input type="text" class="form-control" id="carPurpose">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>

                <button class="btn btn-primary" id="reserveBtn">예약</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById("reserveBtn").addEventListener("click", function () {
        var startDate = document.getElementById("carStartDate").value;
        var startHour = document.getElementById("carStartHour").value;
        var endDate = document.getElementById("carEndDate").value;
        var endHour = document.getElementById("carEndHour").value;
        var purpose = document.getElementById("carPurpose").value.trim();

        if (!startDate || !endDate || startHour === "" || endHour === "" || purpose === "") {
            alert("모든 정보를 입력해주세요.");
            return;
        }


        const start = new Date(startDate + "T" + startHour.padStart(2, "0") + ":00:00");
        const end = new Date(endDate + "T" + endHour.padStart(2, "0") + ":00:00");

        if (start >= end) {
            alert("시작일시가 종료일시보다 같거나 늦을 수 없습니다.");
            return;
        }

        console.log("예약 시작: " + start);
        console.log("예약 종료: " + end);
        console.log("목적: " + purpose);

        document.getElementById("startAt").value = start;
        document.getElementById("endAt").value = end;
        document.getElementById("rentalPurpose").value = purpose;

        document.getElementById("reserveForm").submit(); // 폼 전송
        // 이후 서버로 전송하거나 form에 값 넣기
    });
</script>

<script>
    function openModal(id, model, type) {
        document.getElementById('reserveInfo').innerText = '차량번호: ' + id + ' / 차량명: ' + model;
        const modal = new bootstrap.Modal(document.getElementById('reserveModal'));
        document.querySelector("#facId").value = id; //form에 fac_id값전송
        modal.show();
    }
</script>
</body>
</html>
