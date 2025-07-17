<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-label {
            font-weight: bold;
        }
        .container {
            max-width: 800px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h3 class="fw-bold mb-4">공지사항 작성</h3>

    <!-- 파일 업로드를 위해 multipart/form-data 필요 -->
    <form action="noticeWriteProc.jsp" method="post" enctype="multipart/form-data">
        <!-- 제목 -->
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required placeholder="공지 제목을 입력하세요">
        </div>

        <!-- 작성자 -->
        <div class="mb-3">
            <label for="writer" class="form-label">작성자</label>
            <input type="text" class="form-control" id="writer" name="writer" required placeholder="작성자 이름">
        </div>

        <!-- 내용 -->
        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="8" required placeholder="공지 내용을 입력하세요"></textarea>
        </div>

        <!-- 상단 고정 여부 -->
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="isFixed" name="isFixed" value="true">
            <label class="form-check-label" for="isFixed">상단 고정</label>
        </div>

        <!-- 첨부파일 -->
        <div class="mb-4">
            <label for="uploadFile" class="form-label">첨부파일</label>
            <input class="form-control" type="file" id="uploadFile" name="uploadFile" multiple>
        </div>

        <!-- 버튼 영역 -->
        <div class="d-flex justify-content-between">
            <a href="noticeList" class="btn btn-secondary">목록으로</a>
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">리셋</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
