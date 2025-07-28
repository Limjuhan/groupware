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
        }

        .bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }

        .table.bg-glass th,
        .table.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }

        .table a {
            color: #cfe2ff;
            text-decoration: underline;
        }

        .table a:hover {
            color: #ffffff;
        }

        .page-link.bg-glass {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
            border: none;
        }

        .page-link.bg-glass:hover {
            background-color: rgba(255, 255, 255, 0.2) !important;
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
        <h3>📋 일정 목록</h3>
        <a href="getCalendarForm" class="btn btn-primary bg-glass">+ 일정 등록</a>
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
        $.ajax({
            url: '/calendar/CalendarList',
            type: 'GET',
            data: {page},
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
                            '<a href="getCalendarEditForm?scheduleId=' + s.scheduleId + '" class="btn btn-sm btn-warning me-1">수정</a>' +
                            '<button class="btn btn-sm btn-danger" onclick="deleteSchedule(' + s.scheduleId + ')">삭제</button>' +
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

    function deleteSchedule(scheduleId) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.post("/calendar/deleteCalendarByMng", {scheduleId}, function (result) {
            alert("삭제 완료 되었습니다.");
            fetchScheduleList();
        }).fail(function () {
            alert("삭제 중 오류 발생");
        });
    }

    function drawPagination(pagination) {
        const $paging = $('#paginationArea').empty();
        let html = '<nav><ul class="pagination pagination-sm">';
        const {page: currentPage, totalPages, startPage, endPage} = pagination;

        if (currentPage > 1) {
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(1); return false;">&laquo;&laquo;</a></li>';
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + (currentPage - 1) + '); return false;">&laquo;</a></li>';
        }

        for (let i = startPage; i <= endPage; i++) {
            html += '<li class="page-item' + (currentPage === i ? ' active' : '') + '"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + i + '); return false;">' + i + '</a></li>';
        }

        if (currentPage < totalPages) {
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + (currentPage + 1) + '); return false;">&raquo;</a></li>';
            html += '<li class="page-item"><a class="page-link bg-glass" href="#" onclick="fetchScheduleList(' + totalPages + '); return false;">&raquo;&raquo;</a></li>';
        }

        html += '</ul></nav>';
        $paging.append(html);
    }

    $(function () {
        fetchScheduleList();
    });
</script>

</body>
</html>
