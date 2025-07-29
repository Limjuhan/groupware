<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>일정 목록 - LDBSOFT</title>
    <style>
        body {
            background-color: #1e1e1e;
            color: white;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            padding: 20px;
            margin-top: 2rem; /* 상단 여백 축소 */
            margin-left: 220px; /* 사이드바 너비만큼 왼쪽 여백 추가 */
            max-width: 1200px; /* 콘텐츠 너비 제한 */
        }

        @media (max-width: 768px) {
            .container.bg-glass {
                margin-left: 0; /* 작은 화면에서는 여백 제거 */
                max-width: 100%;
            }
        }

        .table.bg-glass th,
        .table.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
            cursor: pointer;
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

        .form-control.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .form-control.bg-glass:focus,
        .form-select.bg-glass:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: none;
        }

        .btn.bg-glass {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .btn.bg-glass:hover {
            background: rgba(255, 255, 255, 0.2) !important;
        }

        .page-link.bg-glass {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
            border: none;
            border-radius: 0.3rem;
        }

        .page-link.bg-glass:hover {
            background: rgba(255, 255, 255, 0.2) !important;
        }

        .pagination .active .page-link {
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
            color: white !important;
        }

        h3 {
            /* text-shadow 제거 */
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                                '<td><a href="getCalendarEditForm?scheduleId=' + schedule.scheduleId + '" class="link-white">' + schedule.scheduleTitle + '</a></td>' +
                                '<td>' + schedule.startAtStr + '</td>' +
                                '<td>' + schedule.endAtStr + '</td>' +
                                '<td>' + schedule.scheduleContent + '</td>' +
                                '<td>' +
                                '<a href="getCalendarEditForm?scheduleId=' + schedule.scheduleId + '" class="btn btn-sm btn-warning bg-glass me-1">수정</a>' +
                                '<button class="btn btn-sm btn-danger bg-glass" onclick="removeSchedule(' + schedule.scheduleId + ')">삭제</button>' +
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
                html += '<li class="page-item"><a class="page-link bg-glass text-white" href="#" onclick="loadSchedules(1); return false;">&laquo;&laquo;</a></li>';
                html += '<li class="page-item"><a class="page-link bg-glass text-white" href="#" onclick="loadSchedules(' + (currentPage - 1) + '); return false;">&laquo;</a></li>';
            }

            for (let i = startPage; i <= endPage; i++) {
                html += '<li class="page-item' + (currentPage === i ? ' active' : '') + '">' +
                    '<a class="page-link bg-glass text-white" href="#" onclick="loadSchedules(' + i + '); return false;">' + i + '</a></li>';
            }

            if (currentPage < totalPages) {
                html += '<li class="page-item"><a class="page-link bg-glass text-white" href="#" onclick="loadSchedules(' + (currentPage + 1) + '); return false;">&raquo;</a></li>';
                html += '<li class="page-item"><a class="page-link bg-glass text-white" href="#" onclick="loadSchedules(' + totalPages + '); return false;">&raquo;&raquo;</a></li>';
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
                if (e.which === 13) { // 엔터 키 입력 시 검색
                    loadSchedules(1);
                }
            });
        });
    </script>
</head>
<body>
<div class="container bg-glass p-4 rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>일정 관리</h3>
        <a href="getCalendarForm" class="btn btn-primary bg-glass">일정 등록</a>
    </div>

    <div class="row mb-3 align-items-end g-2">
        <div class="col-md-3 select-wrapper">
            <label for="searchType" class="form-label small mb-1">검색 기준</label>
            <select id="searchType" class="form-select bg-glass custom-select-arrow">
                <option value="">검색 조건</option>
                <option value="title">제목</option>
                <option value="startAt">시작일</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="keyword" class="form-label small mb-1">검색어 입력</label>
            <input type="text" id="keyword" class="form-control bg-glass" placeholder="검색어 입력">
        </div>
        <div class="col-md-3">
            <label class="form-label small mb-1">&nbsp;</label>
            <button class="btn btn-primary w-100 bg-glass" onclick="loadSchedules(1)">검색</button>
        </div>
    </div>

    <table class="table table-hover table-bordered text-center align-middle bg-glass">
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
</body>
</html>