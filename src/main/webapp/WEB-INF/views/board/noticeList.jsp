<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    </style>
</head>
<body>
<div class="container mt-5">
    <!-- 제목 + 등록 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">공지사항</h3>
        <a onclick="goForm('getNoticeForm')" class="btn btn-primary">공지 등록</a>
    </div>

    <!-- 검색 폼 -->
    <form action="getNoticeList" method="get" class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="noticeTitle">제목</option>
                <option value="memId">작성자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <!-- 공지 테이블 -->
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
            <!-- 상단 고정 공지 -->
            <c:forEach var="p" items="${pinnedList}">
                <tr class='fixed-row'>
                    <td><i class="bi bi-pin-angle-fill text-danger"></i>
                    </td>
                    <td class="notice-title">
                        <a href="getNoticeDetail?id=${p.noticeId}" class="text-decoration-none text-dark">
                                ${p.noticeTitle}
                        </a>
                    </td>
                    <td>${p.memName}</td>
                    <td>${p.updatedAtToStr}</td>
                    <td>${p.noticeCnt}</td>
                </tr>
            </c:forEach>
            <c:forEach var="n" items="${notice}">
                <tr>
                    <td>
                            ${n.noticeId}
                    </td>
                    <td class="notice-title">
                        <a href="getNoticeDetail?id=${n.noticeId}" class="text-decoration-none text-dark">
                                ${n.noticeTitle}
                        </a>
                    </td>
                    <td>${n.memName}</td>
                    <td>${n.updatedAtToStr}</td>
                    <td>${n.noticeCnt}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이징 UI -->

    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item disabled"><a class="page-link" href="?page=${pageDto.page - 1}">이전</a></li>
            <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="p">
                <li class="page-item ">
                    <a class="page-link" href="?page=${p}">${p}</a>
                </li>
            </c:forEach>
            <li class="page-item"><a class="page-link" href="?page=${pageDto.page+1}">다음</a></li>
        </ul>
    </nav>
</div>
<script>
    function goForm(url){
        let op = "width=600,height=1000,top=50,left=150";
        window.open(url, "", op);
    }
</script>


</body>
</html>