<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>회의실관리 - LDBSOFT 그룹웨어</title>
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

        /* 테이블 컬럼 너비 고정 */
        .table th:nth-child(1), .table td:nth-child(1) {
            width: 15%;
        }

        /* 공용설비ID */
        .table th:nth-child(2), .table td:nth-child(2) {
            width: 30%;
        }

        /* 회의실명 */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 20%;
        }

        /* 식별번호 */
        .table th:nth-child(4), .table td:nth-child(4) {
            width: 10%;
        }

        /* 수용인원 */
        .table th:nth-child(5), .table td:nth-child(5) {
            width: 10%;
        }

        /* 반납여부 */
        .table th:nth-child(6), .table td:nth-child(6) {
            width: 15%;
        }

        /* 관리 */
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">🏢 회의실관리</h2>

    <form id="searchForm" class="row mb-4 g-2 align-items-end">
        <div class="col-md-5">
            <label for="keyword" class="form-label fw-medium">회의실명 / 공용설비ID</label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 대회의실">
        </div>
        <div class="col-md-3">
            <label for="rentYn" class="form-label fw-medium">반납 여부</label>
            <select name="rentYn" id="rentYn" class="form-select">
                <option value="">전체</option>
                <option value="Y">Y</option>
                <option value="N">N</option>
            </select>
        </div>
        <div class="col-md-2 d-grid">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
            </button>
        </div>
        <div class="col-md-2 d-grid">
            <a href="getMeetingRoomForm" class="btn btn-success">
                <i class="fa-solid fa-plus me-1"></i> 회의실 등록
            </a>
        </div>
    </form>

    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>회의실명</th>
            <th>식별번호</th>
            <th>수용인원</th>
            <th>반납여부</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="meetingRoomTable">
        <tr>
            <td colspan="6">데이터를 불러오는 중...</td>
        </tr>
        </tbody>
    </table>

    <nav class="mt-4">
        <ul class="pagination justify-content-center" id="pagination"></ul>
    </nav>
</div>

<script>
    $(function () {
        loadMeetingRoomList(1);

        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadMeetingRoomList(1);
        });
    });

    function loadMeetingRoomList(page) {
        const params = {
            page: page,
            keyword: $("#keyword").val(),
            rentYn: $("#rentYn").val(),
            facType: "R_02"
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

    function renderTable(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = "<tr><td colspan='6'>데이터가 없습니다.</td></tr>";
        } else {
            $.each(list, function (i, v) {
                html += "<tr>"
                    + "<td>" + v.facId + "</td>"
                    + "<td>" + v.facName + "</td>"
                    + "<td>" + v.facUid + "</td>"
                    + "<td>" + v.capacity + "</td>"
                    + "<td>" + v.rentYn + "</td>"
                    + "<td>";
                if (v.rentYn === "Y") {
                    html += "<button class='btn btn-outline-danger btn-sm' "
                        + "onclick=\"confirmDelete('" + v.facId + "','" + v.facName + "','" + v.facType + "')\">삭제하기</button>";
                }
                html += "</td></tr>";
            });
        }
        $("#meetingRoomTable").html(html);
    }

    function renderPagination(p) {
        let html = "";

        // 이전 버튼
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadMeetingRoomList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }

        // 페이지 번호
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadMeetingRoomList(" + i + ")'>" + i + "</a></li>";
        }

        // 다음 버튼
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadMeetingRoomList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }

        $("#pagination").html(html);
    }


    function confirmDelete(roomId, roomName, facType) {
        if (confirm(roomName + "(" + roomId + ") 회의실을 삭제하시겠습니까?")) {
            location.href = "deleteFacilityByMng?facId=" + roomId + "&facType=" + facType;
        }
    }
</script>
</body>
</html>