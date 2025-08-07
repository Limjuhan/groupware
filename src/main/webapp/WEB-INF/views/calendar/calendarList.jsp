<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>일정 목록 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        /* 공통 컨텐츠 영역 */
        .page-content {
            width: 100%;
            min-height: calc(100vh - 160px);
            display: flex;
            flex-direction: column;
            background-color: #fff;
            padding: 20px;
            box-sizing: border-box;
        }

        /* 페이지 제목 */
        .page-title {
            margin-bottom: 20px;
            font-weight: bold;
        }

        /* 페이지 검색/필터 영역 */
        .page-search {
            margin-bottom: 20px;
        }

        /* 테이블 호버 효과 */
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* 페이지네이션 스타일 커스터마이징 */
        .pagination .page-link {
            border-radius: 0.375rem;
            margin: 0 0.125rem;
        }

        .pagination .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        .pagination .page-item.disabled .page-link {
            background-color: #f8f9fa;
            color: #6c757d;
        }

        .form-label {
            font-weight: 500;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
        }

        .btn-warning, .btn-primary, .btn-danger {
            border-radius: 0.375rem;
        }

        .table {
            border-collapse: collapse;
        }

        .table th, .table td {
            border: 1px solid #dee2e6;
        }

        /* 테이블 컬럼 너비 고정 */
        .table th:nth-child(1), .table td:nth-child(1) {
            width: 25%;
        }

        /* 제목 */
        .table th:nth-child(2), .table td:nth-child(2) {
            width: 15%;
        }

        /* 시작일 */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 15%;
        }

        /* 종료일 */
        .table th:nth-child(4), .table td:nth-child(4) {
            width: 30%;
        }

        /* 내용 */
        .table th:nth-child(5), .table td:nth-child(5) {
            width: 15%;
        }

        /* 관리 */
    </style>
</head>
<body>
<div class="page-content">
    <div class="d-flex justify-content-between align-items-center page-title">
        <h2 class="fw-bold">일정 관리</h2>
        <a href="getCalendarForm" class="btn btn-primary">일정 등록</a>
    </div>

    <div class="row mb-3 align-items-end g-2 page-search">
        <div class="col-md-3">
            <label for="searchType" class="form-label fw-medium">검색 기준</label>
            <select id="searchType" class="form-select">
                <option value="">검색 조건</option>
                <option value="title">제목</option>
                <option value="startAt">시작일</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="keyword" class="form-label fw-medium">검색어</label>
            <input type="text" id="keyword" class="form-control" placeholder="검색어 입력">
        </div>
        <div class="col-md-3">
            <label class="form-label fw-medium d-block">&nbsp;</label>
            <button class="btn btn-primary w-100" onclick="loadSchedules(1)">검색</button>
        </div>
    </div>

    <table class="table table-hover table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>제목</th>
            <th>시작일</th>
            <th>종료일</th>
            <th>내용</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="scheduleTableBody"></tbody>
    </table>

    <div id="paginationArea" class="d-flex justify-content-center mt-4"></div>
</div>
<script>
    // 일정 목록을 불러오는 함수
    function loadSchedules(page = 1) {
        const searchType = $('#searchType').val(); // 검색 조건
        const keyword = $('#keyword').val(); // 검색어

        $.ajax({
            url: '/calendar/CalendarList',
            type: 'GET',
            data: {
                page: page,
                searchType: searchType,
                keyword: keyword
            },
            dataType: 'json',
            success: function (response) {
                const list = response.data.scheduleList; // 일정 목록
                const pagination = response.data.pageDto; // 페이징 정보
                const $tableBody = $('#scheduleTableBody').empty(); // 테이블 본문 초기화

                if (list && list.length > 0) {
                    $.each(list, function (index, schedule) {
                        const row = '<tr>' +
                            '<td>' + schedule.scheduleTitle + '</td>' +
                            '<td>' + schedule.startAtStr + '</td>' +
                            '<td>' + schedule.endAtStr + '</td>' +
                            '<td>' + schedule.scheduleContent + '</td>' +
                            '<td>' +
                            '<a href="getCalendarEditForm?scheduleId=' + schedule.scheduleId + '" class="btn btn-sm btn-warning">수정</a>' +
                            '<button class="btn btn-sm btn-danger ms-3" onclick="removeSchedule(' + schedule.scheduleId + ')">삭제</button>' +
                            '</td>' +
                            '</tr>';
                        $tableBody.append(row);
                    });
                } else {
                    $tableBody.append('<tr><td colspan="5" class="text-center text-muted">등록된 일정이 없습니다.</td></tr>');
                }

                renderPagination(pagination);
            },
            error: function () {
                alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    // 페이징을 렌더링하는 함수
    function renderPagination(pagination) {
        const $pagination = $('#paginationArea').empty();
        const searchType = $('#searchType').val();
        const keyword = $('#keyword').val();

        let html = '<nav><ul class="pagination pagination-sm">';
        const {page: currentPage, totalPages, startPage, endPage} = pagination;

        if (currentPage > 1) {
            html += '<li class="page-item"><a class="page-link" href="#" onclick="loadSchedules(1); return false;">&laquo;&laquo;</a></li>';
            html += '<li class="page-item"><a class="page-link" href="#" onclick="loadSchedules(' + (currentPage - 1) + '); return false;">&laquo;</a></li>';
        }

        for (let i = startPage; i <= endPage; i++) {
            html += '<li class="page-item' + (currentPage === i ? ' active' : '') + '">' +
                '<a class="page-link" href="#" onclick="loadSchedules(' + i + '); return false;">' + i + '</a></li>';
        }

        if (currentPage < totalPages) {
            html += '<li class="page-item"><a class="page-link" href="#" onclick="loadSchedules(' + (currentPage + 1) + '); return false;">&raquo;</a></li>';
            html += '<li class="page-item"><a class="page-link" href="#" onclick="loadSchedules(' + totalPages + '); return false;">&raquo;&raquo;</a></li>';
        }

        html += '</ul></nav>';
        $pagination.append(html);
    }

    // 일정 삭제 함수
    function removeSchedule(scheduleId) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.post("/calendar/deleteCalendarByMng", {scheduleId}, function (result) {
            alert("삭제 완료되었습니다.");
            loadSchedules();
        }).fail(function () {
            alert("삭제 중 오류가 발생했습니다.");
        });
    }

    $(function () {
        loadSchedules(); // 페이지 로드 시 일정 목록 불러오기

        $('#keyword').keypress(function (e) {
            if (e.which === 13) {
                loadSchedules(1);
            }
        });
    });
</script>
</body>
</html>