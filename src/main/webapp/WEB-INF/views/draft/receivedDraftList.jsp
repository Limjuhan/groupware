<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>받은 전자결재 - LDBSOFT</title>
    <style>
        body { color: white; }

        .container { max-width: 1200px; margin-top: 40px; }

        .table.bg-glass td, .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: "▼";
            position: absolute;
            top: 60%;
            right: 1.0rem;
            transform: translateY(-60%);
            pointer-events: none;
            color: white;
            font-size: 1.2rem;
        }

        .form-select.bg-glass option {
            background-color: #ffffff;
            color: #000000;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
        }

        a.link-white:hover {
            color: #ffffff;
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="text-shadow">받은 전자결재</h2>
    </div>

    <!-- 검색 필터 -->
    <div class="row mb-3 align-items-end g-2">
        <div class="col-md-3 select-wrapper">
            <label for="searchStatus" class="form-label small mb-1">결재 상태</label>
            <select id="searchStatus" class="form-select bg-glass">
                <option value="">전체</option>
                <c:forEach var="status" items="${approvalStatusList}">
                    <option value="${status.commCode}">${status.commName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3 select-wrapper">
            <label for="searchType" class="form-label small mb-1">검색 기준</label>
            <select id="searchType" class="form-select bg-glass">
                <option value="title">제목</option>
                <option value="content">내용</option>
            </select>
        </div>

        <div class="col-md-4">
            <label for="searchKeyword" class="form-label small mb-1">검색어 입력</label>
            <input type="text" class="form-control bg-glass" id="searchKeyword" placeholder="검색어 입력">
        </div>

        <div class="col-md-2">
            <label class="form-label small mb-1">&nbsp;</label>
            <button type="button" class="btn btn-primary w-100 bg-glass" onclick="searchReceivedList()">검색</button>
        </div>
    </div>

    <!-- 결재문서 테이블 -->
    <table class="table table-hover table-bordered text-center align-middle bg-glass" id="approvalTable">
        <thead class="table-light">
        <tr>
            <th>문서번호</th>
            <th>양식</th>
            <th>제목</th>
            <th>문서종료일</th>
            <th>기안자</th>
            <th>1차 결재자</th>
            <th>2차 결재자</th>
            <th>상태</th>
        </tr>
        </thead>
        <tbody id="receivedTableBody"></tbody>
    </table>

    <!-- 페이징 -->
    <div id="pagination" class="d-flex justify-content-center mt-4"></div>
</div>

<script>
    function searchReceivedList(page = 1) {
        const type = $("#searchType").val();
        const keyword = $("#searchKeyword").val().trim();
        const status = $("#searchStatus").val();

        const requestData = {
            searchType: type,
            keyword: keyword,
            searchStatus: status,
            page: page
        };

        $.ajax({
            url: "/draft/searchReceivedDraftList",
            method: "GET",
            data: requestData,
            dataType: "json",
            success: function (res) {
                if (!res.success) {
                    alert("조회 실패: " + res.message);
                    return;
                }

                const list = res.data.data;
                const pageDto = res.data.page;

                const $tbody = $("#receivedTableBody");
                $tbody.empty();

                if (!list || list.length === 0) {
                    $tbody.append("<tr><td colspan='8' class='text-center text-muted'>검색 결과가 없습니다.</td></tr>");
                } else {
                    list.forEach(function (item) {
                        const statusBadge = getStatusBadge(item.status);
                        const formCodeStr = item.formCodeStr || "-";
                        const docEndDate = item.docEndDate || "-";
                        const approver1Name = item.approver1Name || "-";
                        const approver2Name = item.approver2Name || "-";

                        const row = "<tr>" +
                            "<td>" + item.docId + "</td>" +
                            "<td>" + formCodeStr + "</td>" +
                            "<td><a href='receivedDraftDetail?id=" + item.docId + "' class='link-white'>" + item.docTitle + "</a></td>" +
                            "<td>" + docEndDate + "</td>" +
                            "<td>" + item.writer + "</td>" +
                            "<td>" + approver1Name + "</td>" +
                            "<td>" + approver2Name + "</td>" +
                            "<td>" + statusBadge + "</td>" +
                            "</tr>";

                        $tbody.append(row);
                    });
                }

                renderPagination(pageDto);
            },
            error: function () {
                alert("오류 발생: 목록을 불러올 수 없습니다.");
            }
        });
    }

    function renderPagination(pageDto) {
        const $pagination = $("#pagination");
        $pagination.empty();
        if (!pageDto || pageDto.totalPages === 0) return;

        let html = "<nav><ul class='pagination pagination-sm'>";

        if (pageDto.page > 1) {
            html += "<li class='page-item'><a class='page-link bg-glass text-white' href='#' onclick='searchReceivedList(1)'>&laquo;&laquo;</a></li>";
            html += "<li class='page-item'><a class='page-link bg-glass text-white' href='#' onclick='searchReceivedList(" + (pageDto.page - 1) + ")'>&laquo;</a></li>";
        }

        for (let i = pageDto.startPage; i <= pageDto.endPage; i++) {
            html += "<li class='page-item" + (pageDto.page === i ? " active" : "") + "'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchReceivedList(" + i + ")'>" + i + "</a></li>";
        }

        if (pageDto.page < pageDto.totalPages) {
            html += "<li class='page-item'><a class='page-link bg-glass text-white' href='#' onclick='searchReceivedList(" + (pageDto.page + 1) + ")'>&raquo;</a></li>";
            html += "<li class='page-item'><a class='page-link bg-glass text-white' href='#' onclick='searchReceivedList(" + pageDto.totalPages + ")'>&raquo;&raquo;</a></li>";
        }

        html += "</ul></nav>";
        $pagination.html(html);
    }

    function getStatusBadge(status) {
        const map = {
            "0": "badge bg-secondary'>임시저장",
            "1": "badge bg-warning text-dark'>1차결재 대기",
            "2": "badge bg-warning text-dark'>1차결재 승인",
            "3": "badge bg-danger'>1차결재 반려",
            "4": "badge bg-info text-dark'>2차결재 대기",
            "5": "badge bg-success'>2차결재 승인",
            "6": "badge bg-danger'>2차결재 반려"
        };
        return "<span class='" + (map[status] || "badge bg-dark'>알 수 없음") + "</span>";
    }

    $(document).ready(function () {
        $("#searchKeyword").on("keydown", function(e) {
            if (e.key === "Enter" || e.keyCode === 13) {
                searchReceivedList();
            }
        });
        searchReceivedList(1);
    });
</script>

</body>
</html>
