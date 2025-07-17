<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // 세션에서 로그인 사용자 부서 가져오는 예시 (실제 구현에서는 세션 사용)
    String loginDept = "IT팀"; // session.getAttribute("userDept");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
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
<div class="container bg-white p-5 shadow-sm rounded mt-5 mb-5">
    <h3 class="fw-bold mb-4">자주 묻는 질문 등록</h3>

    <form action="faqWriteProc.jsp" method="post">
        <!-- 질문 -->
        <div class="mb-3">
            <label for="question" class="form-label">질문</label>
            <input type="text" class="form-control" id="question" name="question" required placeholder="예: 연차 신청은 어떻게 하나요?">
        </div>

        <!-- 답변 -->
        <div class="mb-3">
            <label for="answer" class="form-label">답변</label>
            <textarea class="form-control" id="answer" name="answer" rows="6" required placeholder="답변을 입력하세요. 예: 인사시스템에서 로그인 후…"></textarea>
        </div>

        <!-- 작성 부서 -->
        <div class="mb-4">
            <label for="dept" class="form-label">작성 부서</label>
            <select class="form-select" id="dept" name="dept" required>
                <option value="">-- 부서 선택 --</option>
                <option value="인사팀" <%= loginDept.equals("인사팀") ? "selected" : "" %>>인사팀</option>
                <option value="IT팀" <%= loginDept.equals("IT팀") ? "selected" : "" %>>IT팀</option>
                <option value="총무팀" <%= loginDept.equals("총무팀") ? "selected" : "" %>>총무팀</option>
                <option value="보안팀" <%= loginDept.equals("보안팀") ? "selected" : "" %>>보안팀</option>
            </select>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a href="faqList.jsp" class="btn btn-outline-secondary">← 목록으로</a>
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
