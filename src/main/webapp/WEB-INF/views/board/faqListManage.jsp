<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ</title>
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
    <div class="d-flex justify-content-end mb-3">
        <b onclick="goForm('getFaqForm')" class="btn btn-outline-primary fw-bold px-4 py-2 rounded-pill shadow-sm">
            <i class="bi bi-plus-circle me-2"></i> 자주 묻는 질문 등록
        </b>
    </div>
    <form action="getFaqListManage" method="get" class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="faqTitle">제목</option>
                <option value="deptName">작성부서</option>
                <option value="all">제목+작성부서</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>



    <div class="accordion" id="faqAccordion">
        <c:forEach var="q" items="${faq}">
            <div class="accordion-item mb-2">
                <h2 class="accordion-header" id="heading${q.faqId}">
                    <button class="accordion-button collapsed"
                            type="button"
                            data-bs-toggle="collapse"
                            data-bs-target="#collapse${q.faqId}"
                            aria-expanded="false"
                            aria-controls="collapse${q.faqId}">
                            ${q.faqTitle}
                    </button>
                </h2>
                <div id="collapse${q.faqId}"
                     class="accordion-collapse collapse"
                     aria-labelledby="heading${q.faqId}"
                     data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <div class="faq-answer mb-2">${q.faqContent}</div>
                        <div class="text-muted small">작성 부서: ${q.deptName}</div>
                    </div>
                    <div class="mt-2">
                        <a onclick="goForm('getFaqEditForm?id=${q.faqId}&page=${pageDto.page}')" class="btn btn-sm btn-outline-secondary">수정</a>
                        <a href="deleteFaqByMng?id=${q.faqId}&page=${pageDto.page}" class="btn btn-sm btn-outline-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                    </div>
                </div>
            </div>
        </c:forEach>
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
<script>
    function goForm(url){
        let op = "width=500,height=700,top=50,left=150";
        window.open(url, "", op);
    }
</script>

</body>
</html>
