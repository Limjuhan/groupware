<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    // 로그인 사용자 정보 예시
    String loginUser = "김사원";

    // 검색 처리
    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int pageSize = 10;

    // 질문 데이터 (하드코딩)
    class Question {
        int id; String title; String content; String writer; String date;
        Question(int id, String title, String content, String writer, String date) {
            this.id = id; this.title = title; this.content = content; this.writer = writer; this.date = date;
        }
    }

    List<Question> allQuestions = new ArrayList<>();
    for (int i = 1; i <= 25; i++) {
        allQuestions.add(new Question(i, "질문 제목 " + i, "질문 내용 예시입니다. " + i, "김사원", "2025-07-09"));
    }

    // 검색 필터링
    List<Question> filtered = new ArrayList<>();
    for (Question q : allQuestions) {
        if (q.title.contains(keyword)) {
            filtered.add(q);
        }
    }

    int total = filtered.size();
    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, total);

    // FAQ 예시 리스트
    class FAQ {
        String q; String a;
        FAQ(String q, String a) { this.q = q; this.a = a; }
    }

    List<FAQ> faqList = Arrays.asList(
        new FAQ("연차 신청은 어떻게 하나요?", "인사 시스템에서 신청 가능합니다."),
        new FAQ("재택근무 기준은 어떻게 되나요?", "부서장 승인 후 가능합니다."),
        new FAQ("메신저는 어디서 설치하나요?", "인트라넷에서 설치 가능합니다.")
    );
%>

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
            <a href="questionWrite" class="btn btn-primary">질문하기</a>
        </div>
    </div>

    <!-- 검색 -->
    <form method="get" class="row g-2 mb-3">
        <div class="col-md-10">
            <input type="text" name="keyword" class="form-control" placeholder="제목 검색" value="<%= keyword %>">
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-outline-primary w-100">검색</button>
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
        <%
            if (total == 0) {
        %>
            <tr><td colspan="4" class="text-center text-muted">질문이 없습니다.</td></tr>
        <%
            } else {
                for (int i = start; i < end; i++) {
                    Question q = filtered.get(i);
        %>
            <tr>
                <td><%= q.id %></td>
                <td class="question-title">
                    <a href="questionDetail?id=<%= q.id %>" class="text-decoration-none"><%= q.title %></a>
                </td>
                <td><%= q.writer %></td>
                <td><%= q.date %></td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <!-- 페이징 -->
    <%
        int totalPages = (int)Math.ceil(total / (double)pageSize);
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
    </nav>
    <%
        }
    %>
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
                    <%
                        for (int i = 0; i < faqList.size(); i++) {
                            FAQ faq = faqList.get(i);
                    %>
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading<%=i%>">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%=i%>">
                                <%= faq.q %>
                            </button>
                        </h2>
                        <div id="collapse<%=i%>" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body"><%= faq.a %></div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
