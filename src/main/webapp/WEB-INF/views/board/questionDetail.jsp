<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 로그인 사용자 정보 (세션에서 대체 가능)
    String loginUser = "김사원";
    int loginLevel = 1;

    // 글 정보 예시 (DB에서 가져온다고 가정)
    int id = Integer.parseInt(request.getParameter("id"));
    String title = "연차 신청은 어떻게 하나요?";
    String content = "연차는 사내 HR 시스템에서 신청할 수 있습니다.\n인트라넷 접속 후 [연차 신청] 메뉴를 클릭하세요.";
    String writer = "김사원";
    String date = "2025-07-09";

    // 댓글 데이터 예시
    class Comment {
        String writer;
        String text;
        String date;
        Comment(String w, String t, String d) { writer = w; text = t; date = d; }
    }

    List<Comment> comments = Arrays.asList(
        new Comment("관리자", "해당 내용은 사내 포털에도 안내되어 있습니다.", "2025-07-09"),
        new Comment("이대리", "저도 궁금했는데 감사합니다!", "2025-07-09")
    );
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 860px;
        }
        .question-box {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .question-title {
            font-size: 1.6rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .question-meta {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 1.5rem;
        }
        .question-content {
            font-size: 1rem;
            line-height: 1.7;
            white-space: pre-wrap;
            color: #212529;
        }
        .btn-group {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        .comment-box {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 30px;
        }
        .comment-item {
            border-bottom: 1px solid #eee;
            padding: 12px 0;
        }
        .comment-meta {
            font-size: 0.85rem;
            color: #6c757d;
        }
    </style>
</head>
<body>

<div class="container mt-5">

    <!-- 질문 박스 -->
    <div class="question-box">
        <div class="question-title"><%= title %></div>
        <div class="question-meta">작성자: <%= writer %> | 작성일: <%= date %></div>
        <div class="question-content"><%= content %></div>

        <!-- 수정/삭제 버튼 -->
        <div class="btn-group">
            <a href="questionList" class="btn btn-outline-secondary">← 목록으로</a>
            <%
                if (loginUser.equals(writer) || loginLevel >= 2) {
            %>
            <div>
                <a href="questionEdit.jsp?id=<%= id %>" class="btn btn-outline-primary me-2">수정</a>
                <a href="questionDelete.jsp?id=<%= id %>" class="btn btn-outline-danger"
                   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- 댓글 영역 -->
    <div class="comment-box">
        <h5 class="mb-3">댓글 <span class="text-muted">(<%= comments.size() %>)</span></h5>

        <!-- 댓글 리스트 -->
        <%
            for (Comment c : comments) {
        %>
        <div class="comment-item">
            <div><strong><%= c.writer %></strong></div>
            <div class="mb-1"><%= c.text %></div>
            <div class="comment-meta"><%= c.date %></div>
        </div>
        <%
            }
        %>

        <!-- 댓글 작성 폼 -->
        <form action="commentWriteProc.jsp" method="post" class="mt-4">
            <input type="hidden" name="questionId" value="<%= id %>">
            <input type="hidden" name="writer" value="<%= loginUser %>">
            <div class="mb-3">
                <textarea name="text" class="form-control" rows="3" required placeholder="댓글을 입력하세요."></textarea>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-sm btn-primary">댓글 등록</button>
            </div>
        </form>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
