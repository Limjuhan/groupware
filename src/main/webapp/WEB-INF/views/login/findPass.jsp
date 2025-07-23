<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: linear-gradient(135deg, #e0eafc, #cfdef3);
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .find-card {
      background: rgba(255, 255, 255, 0.95);
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 500px;
    }

    .form-label {
      font-weight: 500;
    }

    .form-control {
      border-radius: 8px;
    }

    .form-control:focus {
      box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
    }

    .btn-primary {
      font-weight: bold;
      padding: 10px;
    }

    .text-title {
      font-size: 22px;
      font-weight: bold;
      text-align: center;
      margin-bottom: 25px;
      color: #0d6efd;
    }
  </style>
</head>
<body>
<div class="find-card">
  <div class="text-title">
    🔐 비밀번호 찾기
  </div>
  <form action="findPasswordProc.jsp" method="post">
    <!-- 이름 -->
    <div class="mb-3">
      <label for="name" class="form-label">👤 이름</label>
      <input type="text" class="form-control" id="name" name="name" required placeholder="예: 홍길동">
    </div>

    <!-- 사원번호 -->
    <div class="mb-3">
      <label for="memId" class="form-label">🆔 사원번호</label>
      <input type="text" class="form-control" id="memId" name="memId" required placeholder="예: LDB20240001">
    </div>

    <!-- 2차 이메일 -->
    <div class="mb-4">
      <label for="memPrivateEmail" class="form-label">📧 2차 이메일 (개인 이메일)</label>
      <input type="email" class="form-control" id="memPrivateEmail" name="memPrivateEmail" required placeholder="예: example@gmail.com">
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
