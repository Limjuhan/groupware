<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 600px;
      margin-top: 80px;
    }
    .form-label {
      font-weight: 500;
    }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold text-center">🔐 비밀번호 찾기</h4>

  <form action="findPasswordProc.jsp" method="post">
    <!-- 이름 -->
    <div class="mb-3">
      <label for="name" class="form-label">이름</label>
      <input type="text" class="form-control" id="name" name="name" required placeholder="예: 홍길동">
    </div>

    <!-- 부서 -->
    <div class="mb-3">
      <label for="dept" class="form-label">부서</label>
      <input type="text" class="form-control" id="dept" name="dept" required placeholder="예: 개발팀">
    </div>

    <!-- 이메일 -->
    <div class="mb-3">
      <label for="email" class="form-label">이메일</label>
      <input type="email" class="form-control" id="email" name="email" required placeholder="예: user@example.com">
    </div>

    <!-- 전화번호 -->
    <div class="mb-4">
      <label for="phone" class="form-label">전화번호</label>
      <input type="tel" class="form-control" id="phone" name="phone" required placeholder="예: 010-1234-5678">
    </div>

    <!-- 버튼 -->
    <div class="d-grid">
      <button type="submit" class="btn btn-primary">임시 비밀번호 발송</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
