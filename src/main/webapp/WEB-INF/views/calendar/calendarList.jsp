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
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .table.bg-glass th,
        .table.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
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
        }

        h3 {
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>일정 관리</h3>
        <a href="getCalendarForm" class="btn btn-primary bg-glass">일정 등록</a>
    </div>

    <div class="row mb-3 align-items-end">
        <div class="col-md-3 select-wrapper">
            <label for="searchType" class="form-label">검색 기준</label>
            <select id="searchType" class="form-select bg-glass custom-select-arrow">
                <option value="">검색 조건</option>
                <option value="title">제목</option>
                <option value="startAt">시작일</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="keyword" class="form-label">검색어 입력</label>
            <input type="text" id="keyword" class="form-control bg-glass" placeholder="검색어 입력">
        </div>
        <div class="col-md-3">
            <button class="btn btn-primary w-100 bg-glass" onclick="fetchScheduleList(1)">검색</button>
        </div>
    </div>

    <table class="table table-hover table-bordered text-center align-middle bg-glass">
        <thead class="table-light text-dark">
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

    <div id="paginationArea" class="d-flex justify-content-center mt-3"></div>
</div>

<script>
    function fetchScheduleList(page = 1) {
        const searchType = $('#searchType').val();
        const keyword = $('#keyword').val();

        $.ajax({
            url: '/calendar/CalendarList',
            type: 'GET',
            data: {
                page: page,
                searchType: searchType,
                keyword: keyword
            },
            dataType: 'json',
            success: function (data) {
                const list = data.data.scheduleList;
                const pagination = data.data.pageDto;
                const $tbody = $('#scheduleTableBody').empty();

                if (list && list.length > 0) {
                    $.each(list, function (i, s) {
                        const row = '<tr>' +
                            '<td>' + s.scheduleTitle + '</td>' +
                            '<td>' + s.startAtStr + '</td>' +
                            '<td>' + s.endAtStr + '</td>' +
                            '<td>' + s.scheduleContent + '</td>' +
                            '<td>' +
                            '<a href="getCalendarEditForm?scheduleId=' + s.scheduleId + '" class="btn btn-sm btn-warning bg-glass me-1">수정</a>' +
                            '<button class="btn btn-sm btn-danger bg-glass" onclick="deleteSchedule(' + s.scheduleId + ')">삭제</button>' +
                            '</td>' +
                            '</tr>';
                        $tbody.append(row);
                    });
                } else {
                    $tbody.append('<tr><td colspan="5" class="text-center text-muted">등록된 일정이 없습니다.</td></tr>');
                }

                drawPagination(pagination);
            },
            error: function () {
                alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }

    function drawPagination(pagination) {
        const $paging = $('#paginationArea').empty();
        const searchType = $('#searchType').val();
        const keyword = $('#keyword').val();

        let html = '<nav><ul class="pagination pagination-sm">';
        const {page: currentPage, totalPages, startPage, endPage} = pagination;

        if (currentPage > 1) {
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(1); return false;">&laquo;&laquo;</a></li>';
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + (currentPage - 1) + '); return false;">&laquo;</a></li>';
        }

        for (let i = startPage; i <= endPage; i++) {
            html += '<li class="page-item' + (currentPage === i ? ' active' : '') + '">' +
                '<a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + i + '); return false;">' + i + '</a></li>';
        }

        if (currentPage < totalPages) {
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + (currentPage + 1) + '); return false;">&raquo;</a></li>';
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + totalPages + '); return false;">&raquo;&raquo;</a></li>';
        }

        html += '</ul></nav>';
        $paging.append(html);
    }

    function deleteSchedule(scheduleId) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.post("/calendar/deleteCalendarByMng", {scheduleId}, function (result) {
            alert("삭제 완료 되었습니다.");
            fetchScheduleList();
        }).fail(function () {
            alert("삭제 중 오류 발생");
        });
    }

    $(function () {
        fetchScheduleList();

        $('#keyword').keypress(function (e) {
            if (e.which === 13) {
                fetchScheduleList(1);
            }
        });
    });
</script>

</body>
</html>