<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            max-width: 960px;
        }
        .faq-question {
            font-weight: 600;
            color: #0d6efd;
        }
        .faq-answer {
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h3 class="fw-bold mb-4" style="color: darkgray">자주 묻는 질문 (FAQ)</h3>


    <!-- FAQ 리스트 -->
    <div class="accordion" id="faqAccordion">
        <c:if test="${faq==null}">
            <p class="text-muted">검색 결과가 없습니다.</p>
        </c:if>
        <c:if test="${faq!=null}">
            <c:forEach var="q" items="${faq}">
        <div class="accordion-item mb-2">
            <h2 class="accordion-header" id="heading${q}>">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${q.faqId}">
                        ${q.faqTitle}
                </button>
            </h2>
            <div id="collapse${q.faqId}" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                <div class="accordion-body">
                    <div class="faq-answer mb-2">${q.faqContent}</div>
                    <div class="text-muted small">작성 부서: ${q.deptId}</div>
                </div>
            </div>
        </div>
            </c:forEach>
        </c:if>
    </div>


    <!-- 페이징 -->

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item">
                <a class="page-link" href="?page=${pageDto.page - 1}">이전</a>
            </li>
            <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="p">
                <li class="page-item ">
                    <a class="page-link" href="?page=${p}">${p}</a>
                </li>
            </c:forEach>


            <li class="page-item">
                <a class="page-link" href="?page=${pageDto.page+1}">다음</a>
            </li>
        </ul>
    </nav>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
