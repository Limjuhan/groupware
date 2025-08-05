<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>비품 관리 - LDBSOFT 그룹웨어</title>
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

        /* 공용설비ID*/
        .table th:nth-child(1), .table td:nth-child(1) {
            width: 15%;
        }

        /* 비품명 */
        .table th:nth-child(2), .table td:nth-child(2) {
            width: 30%;
        }

        /* 식별번호 */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 20%;
        }

        /* 수량 */
        .table th:nth-child(4), .table td:nth-child(4) {
            width: 10%;
        }

        /* 반납여부 */
        .table th:nth-child(5), .table td:nth-child(5) {
            width: 10%;
        }

        /* 관리 */
        .table th:nth-child(6), .table td:nth-child(6) {
            width: 15%;
        }

    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">
        <i class="fa-solid fa-box-open me-2"></i> 비품 관리
    </h2>

    <form id="searchForm" class="row mb-4 g-2 align-items-end">
        <div class="col-md-5">
            <label for="keyword" class="form-label fw-medium">비품명 / 공용설비ID</label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 노트북">
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
            <a href="getItemForm" class="btn btn-success">
                <i class="fa-solid fa-plus me-1"></i> 비품 등록
            </a>
        </div>
    </form>

    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>비품명</th>
            <th>식별번호</th>
            <th>수량</th>
            <th>반납여부</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="itemTable">
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
        loadItemList(1);

        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadItemList(1);
        });
    });

    function loadItemList(page) {
        const params = {
            page: page,
            keyword: $("#keyword").val(),
            rentYn: $("#rentYn").val(),
            facType: "R_03"
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
                // 반납여부와 관계없이 삭제 버튼 표시
                html += "<button class='btn btn-outline-danger btn-sm' "
                    + "onclick=\"confirmDelete('" + v.facId + "','" + v.facName + "','" + v.facType + "')\">삭제하기</button>";
                html += "</td></tr>";
            });
        }
        $("#itemTable").html(html);
    }

    function renderPagination(p) {
        let html = "";

        // 이전 버튼
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }

        // 페이지 번호
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadItemList(" + i + ")'>" + i + "</a></li>";
        }

        // 다음 버튼
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }

        $("#pagination").html(html);
    }


    function confirmDelete(itemId, itemName, facType) {
        if (confirm(itemName + "(" + itemId + ") 비품을 삭제하시겠습니까?")) {
            location.href = "deleteFacilityByMng?facId=" + itemId + "&facType=" + facType;
        }
    }
</script>
</body>
</html>