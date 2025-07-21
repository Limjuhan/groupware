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
    <form action="insertNotice" method="post" enctype="multipart/form-data">
        <!-- 제목 -->
        <div class="mb-3">
            <label for="noticeTitle" class="form-label">제목</label>
            <input type="text" class="form-control" id="noticeTitle" name="noticeTitle" required placeholder="공지 제목을 입력하세요">
        </div>

        <!-- 작성자 -->
        <div class="mb-3">
            <label for="memId" class="form-label">작성자</label>
            <input type="text" class="form-control" id="memId" name="memId" required placeholder="작성자 이름">
        </div>

        <!-- 내용 -->
        <div class="mb-3">
            <label for="noticeContent" class="form-label">내용</label>
            <textarea class="form-control" id="noticeContent" name="noticeContent" rows="8" required placeholder="공지 내용을 입력하세요"></textarea>
        </div>

        <!-- 상단 고정 여부 -->
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="isPinned" name="isPinned"  >
            <label class="form-check-label" for="isPinned">상단 고정</label>
        </div>

        <!-- 첨부파일 -->
        <div id="fileInputs">
            <div class="mb-2">
                <input class="form-control" type="file" name="uploadFile" />
            </div>
        </div>
        <button type="button" class="btn btn-outline-secondary" onclick="addFileInput()">+ 파일 추가</button>

        <!-- 버튼 영역 -->
        <div class="d-flex justify-content-between">
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">리셋</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </form>
</div>
<script>
    function addFileInput() {
        const container = document.getElementById("fileInputs");
        const newInput = document.createElement("div");
        newInput.className = "mb-2";
        newInput.innerHTML = '<input class="form-control" type="file" name="uploadFile" />';
        container.appendChild(newInput);
    }
</script>

</body>
</html>
