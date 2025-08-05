<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .notice-table th, .notice-table td {
            vertical-align: middle;
            text-align: center;
        }

        .fixed-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }

        .notice-title {
            text-align: left;
            padding-left: 1rem;
        }

        .disabled-link {
            cursor: not-allowed;
            background-color: #6c757d;
            border-color: #6c757d;
            color: #fff;
            pointer-events: none;
            opacity: 0.65;
            text-decoration: none;
        }

        .page-link {
            cursor: pointer;
        }
    </style>
    <script>
        function goForm(url) {
            var op = "width=600,height=1000,top=50,left=150";
            window.open(url, "", op);
        }

        // 공지사항 목록을 불러오는 함수
        function loadNoticeList(page) {
            if (!page) page = 1;
            var searchType = $('select[name="searchType"]').val();
            var keyword = $('input[name="keyword"]').val();

            $.ajax({
                url: '/api/notice/noticeList',
                type: 'GET',
                data: {
                    page: page,
                    searchType: searchType,
                    keyword: keyword
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        var pinnedList = response.data.pinnedList;
                        var notice = response.data.notice;
                        var pageDto = response.data.pageDto;
                        var $tbody = $('.notice-table tbody').empty();

                        // 상단 고정 공지사항 렌더링
                        $.each(pinnedList, function(index, p) {
                            var pinnedRow = '';
                            pinnedRow += '<tr class="fixed-row">';
                            pinnedRow += '<td><i class="bi bi-pin-angle-fill text-danger"></i></td>';
                            pinnedRow += '<td class="notice-title">';
                            pinnedRow += '<a href="getNoticeDetail?id=' + p.noticeId + '" class="text-decoration-none text-dark">' + p.noticeTitle + '</a>';
                            pinnedRow += '</td>';
                            pinnedRow += '<td>' + p.memName + '</td>';
                            pinnedRow += '<td>' + p.updatedAtToStr + '</td>';
                            pinnedRow += '<td>' + p.noticeCnt + '</td>';
                            pinnedRow += '</tr>';
                            $tbody.append(pinnedRow);
                        });

                        // 일반 공지사항 렌더링
                        if (notice && notice.length > 0) {
                            $.each(notice, function(index, n) {
                                var noticeRow = '';
                                noticeRow += '<tr>';
                                noticeRow += '<td>' + n.noticeId + '</td>';
                                noticeRow += '<td class="notice-title">';
                                noticeRow += '<a href="getNoticeDetail?id=' + n.noticeId + '" class="text-decoration-none text-dark">' + n.noticeTitle + '</a>';
                                noticeRow += '</td>';
                                noticeRow += '<td>' + n.memName + '</td>';
                                noticeRow += '<td>' + n.updatedAtToStr + '</td>';
                                noticeRow += '<td>' + n.noticeCnt + '</td>';
                                noticeRow += '</tr>';
                                $tbody.append(noticeRow);
                            });
                        } else {
                            if(pinnedList.length === 0){
                                $tbody.append('<tr><td colspan="5" class="text-muted">검색 결과가 없습니다.</td></tr>');
                            }
                        }

                        renderPagination(pageDto);

                    } else {
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('공지사항 데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        function renderPagination(pageDto) {
            var $paginationArea = $('.pagination').empty();
            if (!pageDto) return;

            var currentPage = pageDto.page;
            var startPage = pageDto.startPage;
            var endPage = pageDto.endPage;
            var totalPages = pageDto.totalPages;

            var prevClass = currentPage > 1 ? '' : 'disabled';
            $paginationArea.append('<li class="page-item ' + prevClass + '"><a class="page-link" onclick="loadNoticeList(' + (currentPage - 1) + ');">이전</a></li>');

            for (var i = startPage; i <= endPage; i++) {
                var activeClass = currentPage === i ? 'active' : '';
                $paginationArea.append('<li class="page-item ' + activeClass + '"><a class="page-link" onclick="loadNoticeList(' + i + ');">' + i + '</a></li>');
            }

            var nextClass = currentPage < totalPages ? '' : 'disabled';
            $paginationArea.append('<li class="page-item ' + nextClass + '"><a class="page-link" onclick="loadNoticeList(' + (currentPage + 1) + ');">다음</a></li>');
        }

        $(document).ready(function () {
            loadNoticeList(1);

            $('form').on('submit', function (e) {
                e.preventDefault();
                loadNoticeList(1);
            });
        });
    </script>
</head>
<body>
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">공지사항</h3>
        <c:choose>
            <c:when test="${fn:contains(allowedMenus, 'A_0003') || fn:startsWith(sessionScope.loginId,'admin')}">
                <a onclick="goForm('getNoticeForm')" class="btn btn-primary">공지 등록</a>
            </c:when>
        </c:choose>
    </div>

    <form class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="noticeTitle">제목</option>
                <option value="memName">작성자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <div class="table-responsive">
        <table class="table table-bordered table-hover notice-table">
            <thead class="table-light">
            <tr>
                <th style="width: 10%;">공지번호</th>
                <th style="width: 40%;">제목</th>
                <th style="width: 15%;">작성자</th>
                <th style="width: 15%;">작성일</th>
                <th style="width: 10%;">조회수</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
        </ul>
    </nav>
</div>
</body>
</html>