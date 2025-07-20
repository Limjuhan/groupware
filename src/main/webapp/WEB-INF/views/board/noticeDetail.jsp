<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*" %>
<%
    // Mock 데이터 (DB에서 가져오는 부분은 실제 코드로 대체하세요)
    String title = "서버 점검 안내 (7/15)";
    String content = "7월 15일(월) 00:00 ~ 04:00 서버 점검이 예정되어 있습니다.\n해당 시간 동안 그룹웨어 서비스가 일시 중단됩니다.";
    String filename = "server_maintenance.pdf";
    String filepath = "/upload/notice/server_maintenance.pdf";
    String imagePath = "/upload/notice/server_image.png";
    String writer = "관리자";
    String loginUser = "관리자"; // 로그인 세션 사용자
    int userLevel = 2;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
        }

        .wrapper {
            max-width: 850px;
            margin: 50px auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            padding: 40px 50px;
        }

        .title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1d2b53;
        }

        .meta {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }

        .content-box {
            margin-top: 30px;
            font-size: 1rem;
            line-height: 1.8;
            color: #212529;
            white-space: pre-wrap;
        }

        .file-section {
            margin-top: 30px;
            background-color: #f8f9fb;
            border-left: 4px solid #0d6efd;
            padding: 15px 20px;
            border-radius: 6px;
        }

        .file-section a {
            font-weight: 500;
            text-decoration: none;
            color: #0d6efd;
        }

        .image-preview {
            margin-top: 30px;
        }

        .image-preview img {
            max-width: 100%;
            border-radius: 8px;
        }

        .button-group {
            margin-top: 40px;
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }

        .btn-custom {
            padding: 10px 24px;
            font-weight: 500;
            border-radius: 6px;
        }

        .btn-outline-primary {
            border-color: #0d6efd;
            color: #0d6efd;
        }

        .btn-outline-primary:hover {
            background-color: #0d6efd;
            color: #fff;
        }

        .btn-outline-danger:hover {
            background-color: #dc3545;
            color: #fff;
        }

        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <!-- 제목 및 메타 정보 -->
    <div class="title"><%= title %></div>
    <div class="meta">작성자: <%= writer %></div>

    <!-- 본문 내용 -->
    <div class="content-box"><%= content %></div>

    <!-- 첨부파일 -->
    <%
        if (filename != null && !filename.isEmpty()) {
    %>
    <div class="file-section mt-4">
        첨부파일:
        <a href="<%= filepath %>" download><%= filename %></a>
    </div>
    <%
        }
    %>

    <!-- 이미지 미리보기 -->
    <%
        if (imagePath != null && !imagePath.isEmpty()) {
    %>
    <div class="image-preview">
        <img src="<%= imagePath %>" alt="첨부 이미지">
    </div>
    <%
        }
    %>

    <!-- 버튼 그룹 -->
    <div class="button-group">
        <a href="getNoticeList.jsp" class="btn btn-outline-secondary btn-custom">← 목록</a>
        <%
            if (loginUser.equals(writer) || userLevel >= 2) {
        %>
        <div class="d-flex gap-2">
            <a href="noticeEdit?id=101" class="btn btn-outline-primary btn-custom">수정</a>
            <a href="noticeDelete.jsp?id=101" class="btn btn-outline-danger btn-custom"
               onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
