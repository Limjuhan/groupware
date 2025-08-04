<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>차량 관리 - LDBSOFT 그룹웨어</title>
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

        .page-link {
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-0">🚗 차량관리시스템</h2>
    <!-- 검색 및 필터 폼 -->
    <form id="searchForm" class="mb-4">
        <input type="hidden" name="facType" value="vehicle">
        <div class="row mb-3 align-items-end g-2">
            <!-- 차량명/공용설비ID -->
            <div class="col-md-5">
                <label for="keyword" class="form-label fw-medium">차량명 / 공용설비ID</label>
                <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: G70">
            </div>

            <!-- 반납 여부 -->
            <div class="col-md-3">
                <label for="rentYn" class="form-label fw-medium">반납 여부</label>
                <select name="rentYn" id="rentYn" class="form-select">
                    <option value="">전체</option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
            </div>

            <!-- 검색 버튼 -->
            <div class="col-md-2">
                <label class="form-label fw-medium d-block">&nbsp;</label>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
                </button>
            </div>

            <!-- 등록 버튼 -->
            <div class="col-md-2">
                <label class="form-label fw-medium d-block">&nbsp;</label>
                <a href="getVehicleForm" class="btn btn-success w-100">
                    <i class="fa-solid fa-plus me-1"></i> 차량 등록
                </a>
            </div>
        </div>
    </form>

    <!-- 테이블 -->
    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>이름</th>
            <th>차량번호</th>
            <th>수용인원</th>
            <th>반납여부</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="facilityTable">
        <tr>
            <td colspan="6" class="text-center">데이터를 불러오는 중...</td>
        </tr>
        </tbody>
    </table>

    <!-- 페이징 -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center" id="pagination"></ul>
    </nav>
</div>

<script>
    $(document).ready(function () {
        loadFacilityList(1);

        // 검색폼 전송 이벤트
        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadFacilityList(1);
        });
    });

    // 목록 로딩 함수
    function loadFacilityList(page) {
        const params = {
            page: page,
            facType: "R_01",
            keyword: $("#keyword").val(),
            rentYn: $("#rentYn").val()
        };

        $.get("/api/facility/list", params, function (res) {
            if (!res.success) {
                alert(res.message);
                return;
            }
            renderTable(res.data.list);
            renderPagination(res.data.pageDto);
        });
    }

    // 테이블 렌더링
    function renderTable(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = "<tr><td colspan='6'>데이터가 없습니다.</td></tr>";
        } else {
            $.each(list, function (i, c) {
                html += "<tr>"
                    + "<td>" + c.facId + "</td>"
                    + "<td>" + c.facName + "</td>"
                    + "<td>" + c.facUid + "</td>"
                    + "<td>" + c.capacity + "</td>"
                    + "<td>" + c.rentYn + "</td>"
                    + "<td>";
                if (c.rentYn === 'Y') {
                    html += "<button class='btn btn-outline-danger btn-sm' onclick=\"confirmDelete('" + c.facId + "','" + c.facName + "','" + c.facType + "')\">삭제하기</button>";
                }
                html += "</td></tr>";
            });
        }
        $("#facilityTable").html(html);
    }

    // 페이징 렌더링
    // 페이징 렌더링
    function renderPagination(p) {
        let html = "";

        // 이전 버튼
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadFacilityList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }

        // 페이지 번호
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadFacilityList(" + i + ")'>" + i + "</a></li>";
        }

        // 다음 버튼
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadFacilityList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }

        $("#pagination").html(html);
    }


    // 삭제 확인
    function confirmDelete(carId, carName, facType) {
        if (confirm(carName + "(" + carId + ") 차량을 삭제하시겠습니까?")) {
            location.href = "deleteFacilityByMng?facId=" + carId + "&facType=" + facType;
        }
    }
</script>
</body>
</html>
