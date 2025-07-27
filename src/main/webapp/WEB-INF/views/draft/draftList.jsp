<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전자결재 - LDBSOFT</title>
    <style>
        body { color: white; }
        h2 { text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6); }

        #documentTable.bg-glass th,
        #documentTable.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
        }

        a.link-white:hover {
            color: #ffffff;
            text-decoration: underline;
        }

        .form-label { font-weight: bold; }

        .select-wrapper {
            position: relative;
        }

        .form-select.bg-glass.custom-select-arrow {
            appearance: none;
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(1px);
            padding-right: 2.5rem;
            border-radius: 0.5rem;
        }

        .select-wrapper::after {
            content: "▼";
            position: absolute;
            top: 65%;
            right: 1.0rem;
            transform: translateY(-40%);
            pointer-events: none;
            color: white;
            font-size: 1.2rem;
        }

        .form-select.bg-glass option {
            background-color: #ffffff;
            color: #000000;
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>전자결재</h2>
        <a href="draftForm" class="btn btn-primary bg-glass">+ 새 결재문서 작성</a>
    </div>

    <!-- 검색 영역 -->
    <div class="row mb-3 align-items-end">
        <div class="col-md-3 select-wrapper">
            <label for="searchType" class="form-label">검색 기준</label>
            <select id="searchType" class="form-select bg-glass custom-select-arrow">
                <option value="title">제목</option>
                <option value="writer">기안자</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="searchKeyword" class="form-label">검색어 입력</label>
            <input type="text" id="searchKeyword" class="form-control bg-glass" placeholder="검색어 입력">
        </div>
        <div class="col-md-3">
            <button type="button" class="btn btn-primary w-100 bg-glass" onclick="searchMyDraftList()">검색</button>
        </div>
    </div>

    <!-- 결재문서 리스트 -->
    <h5 class="mb-3">내 결재문서 목록</h5>
    <table class="table table-hover table-bordered text-center align-middle bg-glass" id="documentTable">
        <thead class="table-light">
        <tr>
            <th>문서번호</th>
            <th>제목</th>
            <th>문서종료일</th>
            <th>기안자</th>
            <th>1차 결재</th>
            <th>2차 결재</th>
            <th>상태</th>
            <th>삭제</th>
        </tr>
        </thead>
        <tbody id="documentTableBody"></tbody>
    </table>

    <!-- 페이징 -->
    <div id="pagination" class="d-flex justify-content-center mt-4"></div>
</div>

<!-- 이동용 form (POST 방식) -->
<form id="draftMoveForm" method="get" action="draftForm" style="display: none;">
    <input type="hidden" name="docId">
    <input type="hidden" name="memId">
    <input type="hidden" name="formCode">
    <input type="hidden" name="status">
</form>

<script>

    function searchMyDraftList(page = 1) {
        var keyword = $("#searchKeyword").val().trim();
        var type = $("#searchType").val();

        console.log(type);
        console.log(keyword);

        var requestData = {
            type: '',
            keyword: '',
            page: page
        };

        if (keyword !== "" && type !== "") {
            requestData.type = type;
            requestData.keyword = keyword;
        }

        $.ajax({
            url: "/draft/searchMyDraftList",
            method: "GET",
            data: requestData,
            dataType: "json",
            success: function (response) {
                if (!response.success) {
                    alert("조회 실패: " + response.message);
                    return;
                }

                const data = response.data.data;
                const pageDto = response.data.page;

                var $tbody = $("#documentTableBody");
                $tbody.empty();

                if (!data || data.length === 0) {
                    $tbody.append("<tr><td colspan='8' class='text-center text-muted'>검색 결과가 없습니다.</td></tr>");
                } else {
                    data.forEach(function (draft) {
                        var statusBadge = getStatusBadge(draft.status);

                        if (!draft.approver1) draft.approver1 = '-';
                        if (!draft.approver2) draft.approver2 = '-';

                        var row = "<tr>" +
                            "<td>" + draft.docId + "</td>" +
                            "<td><a href='#' onclick=\"moveToDraft('" + draft.docId + "','" + draft.writer + "','" + draft.formCode + "','" + draft.status + "')\" class='link-white'>" + draft.docTitle + "</a></td>" +
                            "<td>" + draft.docEndDate + "</td>" +
                            "<td>" + draft.writer + "</td>" +
                            "<td>" + draft.approver1 + "</td>" +
                            "<td>" + draft.approver2 + "</td>" +
                            "<td>" + statusBadge + "</td>" +
                            "<td><a href='deleteMyDraft?id=" + draft.docId + "' class='btn btn-sm btn-outline-danger bg-glass'>삭제</a></td>" +
                            "</tr>";

                        $tbody.append(row);
                    });
                }

                renderPagination(pageDto);
            },
            error: function () {
                alert("목록을 불러오는 중 오류가 발생했습니다.");
            }
        });
    }

    function renderPagination(pageDto) {
        const $pagination = $("#pagination");
        $pagination.empty();

        if (!pageDto || pageDto.totalPages === 0) return;

        let html = "<nav><ul class='pagination pagination-sm'>";

        // 처음으로
        if (pageDto.page > 1) {
            html += "<li class='page-item'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchMyDraftList(1)'>&laquo;&laquo;</a>" +
                "</li>";
        }

        // 이전
        if (pageDto.page > 1) {
            html += "<li class='page-item'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchMyDraftList(" + (pageDto.page - 1) + ")'>&laquo;</a>" +
                "</li>";
        }

        // 페이지 번호
        for (let i = pageDto.startPage; i <= pageDto.endPage; i++) {
            html += "<li class='page-item" + (pageDto.page === i ? " active" : "") + "'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchMyDraftList(" + i + ")'>" + i + "</a>" +
                "</li>";
        }

        // 다음
        if (pageDto.page < pageDto.totalPages) {
            html += "<li class='page-item'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchMyDraftList(" + (pageDto.page + 1) + ")'>&raquo;</a>" +
                "</li>";
        }

        // 끝으로
        if (pageDto.page < pageDto.totalPages) {
            html += "<li class='page-item'>" +
                "<a class='page-link bg-glass text-white' href='#' onclick='searchMyDraftList(" + pageDto.totalPages + ")'>&raquo;&raquo;</a>" +
                "</li>";
        }

        html += "</ul></nav>";
        $pagination.html(html);
    }



    function moveToDraft(docId, memId, formCode, status) {
        const form = document.getElementById("draftMoveForm");

        // 상태값이 0(임시저장)인 경우 draftForm, 그 외는 getMyDraftDetail
        form.action = (status === "0") ? "draftForm" : "getMyDraftDetail";

        form["docId"].value = docId;
        form["memId"].value = memId;
        form["formCode"].value = formCode;
        form["status"].value = status;

        form.submit();
    }


    function getStatusBadge(status) {
        if (status === "0") {
            return "<span class='badge bg-secondary'>임시저장</span>";
        } else if (status === "1") {
            return "<span class='badge bg-warning text-dark'>1차결재 대기</span>";
        } else if (status === "2") {
            return "<span class='badge bg-warning text-dark'>1차결재 승인</span>";
        } else if (status === "3") {
            return "<span class='badge bg-danger'>1차결재 반려</span>";
        } else if (status === "4") {
            return "<span class='badge bg-info text-dark'>2차결재 대기</span>";
        } else if (status === "5") {
            return "<span class='badge bg-success'>2차결재 승인</span>";
        } else if (status === "6") {
            return "<span class='badge bg-danger'>2차결재 반려</span>";
        } else {
            return "<span class='badge bg-dark'>알 수 없음</span>";
        }
    }

    $(document).ready(function () {
        var errorMessage = '${globalError}';
        if (errorMessage !== '') {
            alert(errorMessage);
        }

        $("#searchKeyword").on("keydown", function(e) {
            if (e.key === "Enter" ||  e.keyCode === 13) {
                // e.preventDefault();
                searchMyDraftList();
            }
        });

        searchMyDraftList(1);
    });
</script>
</body>
</html>
