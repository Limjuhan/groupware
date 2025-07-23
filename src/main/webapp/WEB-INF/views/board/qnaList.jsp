<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 게시판</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 960px; }
        .table th, .table td { vertical-align: middle; text-align: center; }
        .question-title { text-align: left; padding-left: 1rem; }
    </style>
</head>
<body>
<div class="container mt-5">
    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">질문 게시판</h3>
        <div>
            <button type="button" class="btn btn-outline-info me-2" data-bs-toggle="modal" data-bs-target="#faqModal">
                자주 묻는 질문
            </button>
            <a href="getQnaForm?login=admin" class="btn btn-primary">질문하기</a>
        </div>
    </div>

    <form action="getQnaList" method="get" class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="qnaTitle">제목</option>
                <option value="memId">작성자</option>
                <option value="all">제목+작성자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <!-- 질문 테이블 -->
    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
            <tr>
                <th style="width: 10%;">번호</th>
                <th style="width: 50%;">제목</th>
                <th style="width: 20%;">작성자</th>
                <th style="width: 20%;">작성일</th>
            </tr>
        </thead>
        <tbody>
        <c:if test="${qna==null}">
            <tr>
                <td colspan="4">게시물 없음</td>
            </tr>
        </c:if>
        <c:forEach items="${qna}" var="q">
            <tr>
                <td>${q.qnaId}</td>
                <td class="question-title">
                    <a href="getQnaDetail?id=${q.qnaId}" class="text-decoration-none">${q.qnaTitle}</a>
                </td>
                <td>${q.memName}</td>
                <td>${q.dateFormat}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>


    <nav class="mt-4">
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

<!-- FAQ Modal -->
<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">자주 묻는 질문 (FAQ)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">

                    <div class="accordion" id="faqAccordion">
                        <c:forEach items="${faq}" var="f" varStatus="status">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="heading${status.index}">
                                <button class="accordion-button collapsed"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#collapse${status.index}" <%-- 해당id를 가진 토글을 접기/펴기--%>
                                       >
                                    <%-- 현재 연결된 콘텐츠가 펼쳐져 있지 않음을 스크린 리더에 알려줌
                                            JavaScript가 자동으로 true/false를 토글함--%>
                                        ${f.faqTitle}
                                </button>
                            </h2>
                            <div id="collapse${status.index}" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">${f.faqContent}</div>
                            </div>
                        </div>
                        </c:forEach>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
