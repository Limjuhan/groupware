<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*" %>
<%
    // Mock 데이터 (수정 페이지 진입 시 기존 값 불러오는 부분)
    String id = request.getParameter("id"); // 게시글 ID
    String title = "서버 점검 안내 (7/15)";
    String content = "7월 15일(월) 00:00 ~ 04:00 서버 점검이 예정되어 있습니다.\n해당 시간 동안 그룹웨어 서비스가 일시 중단됩니다.";
    String filename = "server_maintenance.pdf";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 800px;
            margin-top: 50px;
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            font-weight: bold;
            margin-bottom: 30px;
        }
        .btn-custom {
            min-width: 100px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📌 공지사항 수정</h2>
    <form action="noticeEditProcess.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= id %>">

        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" value="<%= title %>" required>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="8" required><%= content %></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">첨부파일</label><br>
            <%
                if (filename != null && !filename.isEmpty()) {
            %>
                현재 파일: <strong><%= filename %></strong><br>
            <%
                }
            %>
            <input type="file" name="uploadFile" class="form-control mt-2">
        </div>

        <div class="d-flex justify-content-between mt-4">
            <a href="getNoticeDetail.jsp?id=<%= id %>" class="btn btn-secondary btn-custom">취소</a>
            <button type="submit" class="btn btn-primary btn-custom">저장</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
