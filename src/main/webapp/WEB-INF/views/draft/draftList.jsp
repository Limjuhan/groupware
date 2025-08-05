<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전자결재 - LDBSOFT</title>
    <style>
        /* 공통 컨텐츠 영역 */
        .page-content {
            width: 100%; /* sidebar 제외 나머지 폭 전부 */
            min-height: calc(100vh - 160px); /* 상단바 + 여백 제외한 높이 */
            display: flex;
            flex-direction: column;
            background-color: #fff;
            padding: 20px;
            box-sizing: border-box;
        }
        /* 검색 영역 */
        .page-search {
            margin-bottom: 20px;
        }
        /* 페이지 제목 */
        .page-title {
            margin-bottom: 20px;
            font-weight: bold;
        }
        a.link-white:hover {
            color: #ffffff;
            text-decoration: underline;
        }
        .form-label {
            font-weight: bold;
        }
        .select-wrapper {
            position: relative;
        }
        /* 테이블 컬럼 폭 조정 */
        #documentTable th:nth-child(1), /* 문서번호 */
        #documentTable td:nth-child(1) {
            width: 8%;
        }

        #documentTable th:nth-child(2), /* 양식 */
        #documentTable td:nth-child(2) {
            width: 12%;
        }

        #documentTable th:nth-child(3), /* 제목 */
        #documentTable td:nth-child(3) {
            width: 30%;
        }

        #documentTable th:nth-child(4), /* 문서종료일 */
        #documentTable td:nth-child(4) {
            width: 12%;
        }

        #documentTable th:nth-child(5), /* 기안자 */
        #documentTable td:nth-child(5) {
            width: 10%;
        }

        #documentTable th:nth-child(6), /* 1차 결재 */
        #documentTable td:nth-child(6),
        #documentTable th:nth-child(7), /* 2차 결재 */
        #documentTable td:nth-child(7) {
            width: 10%;
        }

        #documentTable th:nth-child(8), /* 상태 */
        #documentTable td:nth-child(8) {
            width: 8%;
        }

        #documentTable th:nth-child(9), /* 삭제 */
        #documentTable td:nth-child(9) {
            width: 6%;
        }
        #documentTable {
            table-layout: fixed;
            word-break: break-word;
        }
    </style>
</head>
<body>

<div class="page-content">
    <!-- 페이지 제목 -->
    <div class="d-flex justify-content-between align-items-center page-title">
        <h2>전자결재</h2>
        <a href="draftForm" class="btn btn-primary">+ 새 결재문서 작성</a>
    </div>

    <!-- 검색 영역 -->
    <div class="row align-items-end g-2 page-search">
        <!-- 결재 상태 -->
        <div class="col-md-3 select-wrapper">
            <label for="searchStatus" class="form-label small mb-1">결재 상태</label>
            <select id="searchStatus" class="form-select">
                <option value="">전체</option>
                <c:forEach var="status" items="${approvalStatusList}">
                    <option value="${status.commCode}">${status.commName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- 검색 기준 -->
        <div class="col-md-3 select-wrapper">
            <label for="searchType" class="form-label small mb-1">검색 기준</label>
            <select id="searchType" class="form-select">
                <option value="title">제목</option>
                <option value="content">내용</option>
            </select>
        </div>

        <!-- 검색어 입력 -->
        <div class="col-md-4">
            <label for="searchKeyword" class="form-label small mb-1">검색어 입력</label>
            <input type="text" id="searchKeyword" class="form-control" placeholder="검색어 입력">
        </div>

        <!-- 검색 버튼 -->
        <div class="col-md-2">
            <label class="form-label small mb-1">&nbsp;</label>
            <button type="button" class="btn btn-primary w-100" onclick="searchMyDraftList()">검색</button>
        </div>
    </div>

    <!-- 결재문서 리스트 -->
    <h5 class="mb-3">내 결재문서 목록</h5>
    <table class="table table-hover table-bordered text-center align-middle" id="documentTable">
        <thead class="table-light">
        <tr>
            <th>문서번호</th>
            <th>양식</th>
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

<!-- 이동용 form -->
<form id="draftMoveForm" method="get" action="draftForm" style="display:none;">
    <input type="hidden" name="docId">
    <input type="hidden" name="memId">
    <input type="hidden" name="formCode">
    <input type="hidden" name="status">
</form>

<script>
    function searchMyDraftList(page) {
        if (!page) page = 1;
        var keyword = $("#searchKeyword").val().trim();
        var searchType = $("#searchType").val();
        var searchStatus = $("#searchStatus").val();

        var requestData = {
            searchType: '',
            keyword: '',
            page: page,
            searchStatus: searchStatus
        };

        if (keyword !== "" && searchType !== "") {
            requestData.searchType = searchType;
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
                    $tbody.append("<tr><td colspan='9' class='text-center text-muted'>검색 결과가 없습니다.</td></tr>");
                } else {
                    data.forEach(function (draft) {
                        var statusBadge = getStatusBadge(draft.status);

                        if (!draft.approver1Name) draft.approver1Name = '-';
                        if (!draft.approver2Name) draft.approver2Name = '-';
                        if (!draft.docEndDate) draft.docEndDate = '-';
                        if (!draft.docTitle) draft.docTitle = '-';

                        var isTemp = (draft.status == 0)
                            ? "<td><a href='#' onclick=\"deleteMyDraft('" + draft.docId + "','" + draft.formCode + "','" + draft.status + "')\" class='btn btn-sm btn-outline-danger'>삭제</a></td>"
                            : "<td>-</td>";

                        var row = "<tr class='" + (draft.readYn === 'N' ? "fw-bold" : "text-muted") + "'>" +
                            "<td>" + draft.docId + "</td>" +
                            "<td>" + draft.formCodeStr + "</td>" +
                            "<td><a href='#' onclick=\"moveToDraft('" + draft.docId + "','" + draft.writer + "','" + draft.formCode + "','" + draft.status + "','" + draft.readYn + "')\" class='link-white'>" + draft.docTitle + "</a></td>" +
                            "<td>" + draft.docEndDate + "</td>" +
                            "<td>" + draft.writer + "</td>" +
                            "<td>" + draft.approver1Name + "</td>" +
                            "<td>" + draft.approver2Name + "</td>" +
                            "<td>" + statusBadge + "</td>" +
                            isTemp +
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

        var html = "<nav><ul class='pagination pagination-sm'>";

        if (pageDto.page > 1) {
            html += "<li class='page-item'><a class='page-link' href='#' onclick='searchMyDraftList(1)'>&laquo;&laquo;</a></li>";
            html += "<li class='page-item'><a class='page-link' href='#' onclick='searchMyDraftList(" + (pageDto.page - 1) + ")'>&laquo;</a></li>";
        }

        for (var i = pageDto.startPage; i <= pageDto.endPage; i++) {
            html += "<li class='page-item" + (pageDto.page === i ? " active" : "") + "'><a class='page-link' href='#' onclick='searchMyDraftList(" + i + ")'>" + i + "</a></li>";
        }

        if (pageDto.page < pageDto.totalPages) {
            html += "<li class='page-item'><a class='page-link' href='#' onclick='searchMyDraftList(" + (pageDto.page + 1) + ")'>&raquo;</a></li>";
            html += "<li class='page-item'><a class='page-link' href='#' onclick='searchMyDraftList(" + pageDto.totalPages + ")'>&raquo;&raquo;</a></li>";
        }

        html += "</ul></nav>";
        $pagination.html(html);
    }

    function moveToDraft(docId, memId, formCode, status, readYn) {
        if (readYn === 'N') {
            $.ajax({
                url: "/alarm/markAsRead",
                type: "POST",
                contentType: "application/json",
                data: { docId: docId, memId: memId, readYn: 'Y' },
                async: false
            });
        }

        var form = document.getElementById("draftMoveForm");
        form.action = (status === "0") ? "draftForm" : "getMyDraftDetail";
        form["docId"].value = docId;
        form["memId"].value = memId;
        form["formCode"].value = formCode;
        form["status"].value = status;
        form.submit();
    }

    function deleteMyDraft(docId, formCode, status) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.ajax({
            type: "POST",
            url: "/draft/deleteMyDraft",
            contentType: "application/json",
            data: JSON.stringify({
                docId: docId,
                formCode: formCode,
                status: status
            }),
            success: function (res) {
                if (res.success) {
                    alert("삭제되었습니다.");
                    location.reload();
                } else {
                    alert("삭제 실패: " + res.message);
                }
            },
            error: function (xhr) {
                alert("삭제 요청 중 오류 발생");
            }
        });
    }

    function getStatusBadge(status) {
        if (status === "0") return "<span class='badge bg-secondary'>임시저장</span>";
        if (status === "1") return "<span class='badge bg-warning text-dark'>1차결재 대기</span>";
        if (status === "2") return "<span class='badge bg-warning text-dark'>1차결재 승인</span>";
        if (status === "3") return "<span class='badge bg-danger'>1차결재 반려</span>";
        if (status === "4") return "<span class='badge bg-info text-dark'>2차결재 대기</span>";
        if (status === "5") return "<span class='badge bg-success'>2차결재 승인</span>";
        if (status === "6") return "<span class='badge bg-danger'>2차결재 반려</span>";
        return "<span class='badge bg-dark'>알 수 없음</span>";
    }

    $(document).ready(function () {
        var errorMessage = '${globalError}';
        if (errorMessage !== '') alert(errorMessage);

        var confirmMsg = '${message}';
        if (confirmMsg !== '') alert(confirmMsg);

        $("#searchKeyword").on("keydown", function(e) {
            if (e.key === "Enter" || e.keyCode === 13) searchMyDraftList();
        });

        searchMyDraftList(1);
    });
</script>
</body>
</html>
