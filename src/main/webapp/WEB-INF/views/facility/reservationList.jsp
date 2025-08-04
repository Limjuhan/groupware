<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>예약내역 - LDBSOFT 그룹웨어</title>
    <style>
        body {
            background-color: #f4f6f9;
        }

        .container {
            max-width: 1100px;
            margin-top: 40px;
        }

        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">📋 내 예약내역</h2>

    <!-- 검색/필터 -->
    <form id="searchForm" class="row g-2 mb-3">
        <div class="col-auto">
            <input type="month" class="form-control" name="yearMonth" id="yearMonth"/>
        </div>
        <div class="col-auto">
            <select class="form-select" name="facType" id="facType">
                <option value="">전체유형</option>
                <option value="R_01">차량</option>
                <option value="R_02">회의실</option>
                <option value="R_03">비품</option>
            </select>
        </div>
        <div class="col-auto">
            <input type="text" class="form-control" name="keyword" id="keyword" placeholder="이름 또는 차종/회의실명"/>
        </div>
        <div class="col-auto form-check align-self-center">
            <input type="checkbox" id="includeCancel" name="includeCancel" value="true">
            <label class="form-check-label">취소 포함</label>
        </div>
        <div class="col-auto">
            <button class="btn btn-primary" type="submit">검색</button>
        </div>
    </form>

    <!-- 예약 리스트 -->
    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>유형</th>
            <th>이름</th>
            <th>식별번호</th>
            <th>예약일</th>
            <th>예약기간</th>
            <th>반납</th>
            <th>상태/취소</th>
        </tr>
        </thead>
        <tbody id="reservationTable">
        <tr>
            <td colspan="8">예약한 리스트가 없습니다.</td>
        </tr>
        </tbody>
    </table>

    <!-- 페이징 -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center" id="pagination"></ul>
    </nav>
</div>

<script>
    $(function () {
        // 첫 로딩
        loadReservations(1);

        // 검색 이벤트
        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadReservations(1);
        });
    });

    // 예약 목록 불러오기
    function loadReservations(page) {
        const params = {
            page: page,
            yearMonth: $("#yearMonth").val(),
            facType: $("#facType").val(),
            keyword: $("#keyword").val(),
            includeCancel: $("#includeCancel").is(":checked") ? "true" : "false"
        };

        $.get("/api/facility/myReservation", params, function (res) {
            if (!res.success) {
                alert(res.message);
                return;
            }
            renderTable(res.data.facility);
            renderPagination(res.data.pageDto);
        });
    }

    function renderTable(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = "<tr><td colspan='8'>데이터가 없습니다.</td></tr>";
        } else {
            $.each(list, function (i, f) {
                html += "<tr>"
                    + "<td>" + f.facId + "</td>"
                    + "<td>" + f.commName + "</td>"
                    + "<td>" + f.facName + "</td>"
                    + "<td>" + f.facUid + "</td>"
                    + "<td>" + f.createdAt + "</td>"
                    + "<td>" + f.startAt + " ~ " + f.endAt + "</td>"
                    + "<td>";
                if (f.rentYn === "N" && f.cancelStatus === "N") {
                    html += "<button type='button' class='btn btn-sm btn-outline-success' onclick=\"returnFacility('" + f.facId + "')\">반납</button>";
                }
                html += "</td><td>";
                if (f.cancelStatus === "Y" && f.rentYn === "Y") {
                    html += "<span class='text-danger fw-bold'>[취소됨]</span>";
                } else if (f.rentYn === "Y") {
                    html += "<span class='text-success fw-bold'>[반납완료]</span>";
                } else {
                    html += "<button type='button' class='btn btn-outline-danger btn-sm' onclick=\"delReserve('" + f.facId + "')\">취소</button>";
                }
                html += "</td></tr>";
            });
        }
        $("#reservationTable").html(html);
    }

    function renderPagination(p) {
        let html = "";

        // 이전 버튼 (첫 페이지 아니면 항상 표시)
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadReservations(" + (p.page - 1) + ")'>이전</a></li>";
        }

        // 페이지 번호
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadReservations(" + i + ")'>" + i + "</a></li>";
        }

        // 다음 버튼 (마지막 페이지 아니면 항상 표시)
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadReservations(" + (p.page + 1) + ")'>다음</a></li>";
        }

        $("#pagination").html(html);
    }


    function delReserve(facId) {
        if (confirm("예약을 취소하시겠습니까?")) {
            location.href = "cancelReservation?facId=" + facId;
        }
    }

    function returnFacility(facId) {
        if (confirm("반납처리를 하겠습니까?")) {
            location.href = "returnFacility?facId=" + facId;
        }
    }
</script>

</body>
</html>
