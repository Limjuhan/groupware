<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
    // 예시 로그인 정보 (실제 환경에서는 세션에서 가져옴)
    String loginDept = "인사팀";
    int loginLevel = 2;

    // 검색 키워드 받기
    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";

    // 페이징 하드코딩 (실제 데이터베이스 연동 시 DAO에서 처리)
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int pageSize = 10;

    class FAQ {
        int id;
        String question;
        String answer;
        String dept;
        FAQ(int id, String q, String a, String d) {
            this.id = id; this.question = q; this.answer = a; this.dept = d;
        }
    }

    List<FAQ> faqList = new ArrayList<>();
    faqList.add(new FAQ(1, "연차 신청 방법은?", "인사시스템에서 신청 가능합니다.", "인사팀"));
    faqList.add(new FAQ(2, "재택근무 기준은?", "부서장 승인 후 가능하며 사전 보고가 필요합니다.", "총무팀"));
    faqList.add(new FAQ(3, "보안 교육 수강은 어디서?", "보안 포털에서 로그인 후 수강 가능합니다.", "보안팀"));
    faqList.add(new FAQ(4, "회사 이메일 세팅은?", "IT팀에 요청 후 매뉴얼 제공됩니다.", "IT팀"));
    faqList.add(new FAQ(5, "사내 메신저 설치는?", "인프라 포털에서 다운로드 가능합니다.", "IT팀"));
    // 총 5개만 예시로 표시 (실제 환경에서는 페이징 고려)

    // 검색 필터링
    List<FAQ> filteredList = new ArrayList<>();
    for (FAQ faq : faqList) {
        if (faq.question.contains(keyword)) {
            filteredList.add(faq);
        }
    }

    int totalFAQs = filteredList.size();
    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, totalFAQs);
--%>

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
    <h3 class="fw-bold mb-4">자주 묻는 질문 (FAQ)</h3>


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





    <%--
    <!-- 페이징 -->
    <%
        int totalPages = (int)Math.ceil(totalFAQs / (double)pageSize);
        if (totalPages > 1) {
    %>
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="?page=<%= currentPage - 1 %>&keyword=<%= keyword %>">이전</a>
            </li>
            <%
                for (int i = 1; i <= totalPages; i++) {
            %>
            <li class="page-item <%= currentPage == i ? "active" : "" %>">
                <a class="page-link" href="?page=<%= i %>&keyword=<%= keyword %>"><%= i %></a>
            </li>
            <%
                }
            %>
            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                <a class="page-link" href="?page=<%= currentPage + 1 %>&keyword=<%= keyword %>">다음</a>
            </li>
        </ul>
    </nav> --%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
