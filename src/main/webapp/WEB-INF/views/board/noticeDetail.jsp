<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
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
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
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
    <div class="title">${notice.noticeTitle}</div>
    <div class="meta">작성자: ${notice.memName}</div>

    <!-- 본문 내용 -->
    <div class="content-box">${notice.noticeContent}</div>


    <c:if test="${attach != null }">
        <c:forEach items="${attach}" var="a">
            <c:if test="${a.filePath != null}">
                <div class="file-section mt-4">
                    첨부파일:
                    <a href="${a.filePath}${a.savedName}" download="${a.originalName}">${a.originalName}</a>
                </div>
            </c:if>
        </c:forEach>
    </c:if>

    <!-- 버튼 그룹 -->
    <div class="button-group">
        <a href="getNoticeList" class="btn btn-outline-secondary btn-custom">← 목록</a>

        <div class="d-flex gap-2">
            <c:choose>
                <c:when test="${fn:contains(allowedMenus, 'A_0003')}">
                    <a onclick="goForm('getNoticeEditForm?id=${notice.noticeId}')"
                       class="btn btn-outline-primary btn-custom">수정</a>
                    <a href="deleteNoticeByMng?id=${notice.noticeId}" class="btn btn-outline-danger btn-custom"
                       onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>
<script>
    function goForm(url) {
        let op = "width=600,height=1000,top=50,left=150";
        window.open(url, "", op);
    }

</script>
</body>
</html>
