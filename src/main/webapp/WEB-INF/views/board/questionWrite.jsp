<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // 로그인된 사용자 이름 (세션에서 가져오는 예시)
    String loginUser = "김사원"; // session.getAttribute("username") 등으로 처리 가능
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f6f8fa;
        }
        .container {
            max-width: 800px;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container mt-5 mb-5 bg-white p-5 shadow-sm rounded">
    <h3 class="fw-bold mb-4">질문 작성</h3>

    <form action="questionWriteProc.jsp" method="post">
    <!-- 작성자 (자동 입력) -->
        <div class="mb-4">
            <label for="writer" class="form-label">작성자</label>
            <input type="text" class="form-control" id="writer" name="writer" value="<%= loginUser %>" readonly>
        </div>
        <!-- 제목 -->
        <div class="mb-3">
            <label for="title" class="form-label">질문 제목</label>
            <input type="text" class="form-control" id="title" name="title" required placeholder="예: 연차 신청은 어떻게 하나요?">
        </div>

        <!-- 내용 -->
        <div class="mb-3">
            <label for="content" class="form-label">질문 내용</label>
            <textarea class="form-control" id="content" name="content" rows="7" required placeholder="질문의 상세 내용을 입력해 주세요."></textarea>
        </div>

        

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a href="questionList" class="btn btn-outline-secondary">← 목록으로</a>
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">초기화</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
