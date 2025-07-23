<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 변경</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: linear-gradient(135deg, #e0eafc, #cfdef3);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', sans-serif;
    }

    .password-card {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 16px;
      padding: 40px 30px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
      width: 100%;
      max-width: 450px;
    }

    .password-card h4 {
      font-weight: bold;
      text-align: center;
      margin-bottom: 25px;
      color: #0d6efd;
    }

    .form-label {
      font-weight: 500;
      color: #333;
    }

    .form-label i {
      margin-right: 8px;
      color: #0d6efd;
    }

    .form-control {
      border-radius: 8px;
    }

    .form-control:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.2);
    }

    .btn-primary {
      font-weight: bold;
      padding: 8px 20px;
    }

    .btn-secondary {
      padding: 8px 20px;
    }

    .btn-group {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }

    @media (max-width: 480px) {
      .btn-group {
        flex-direction: column;
        gap: 10px;
      }
    }
  </style>
</head>
<body>

<div class="password-card">
  <h4><i class="fa-solid fa-key"></i> 비밀번호 변경</h4>
  <form method="post" action="/member/updatePassword">
    <div class="mb-3">
      <label for="currentPassword" class="form-label"><i class="fa-solid fa-lock"></i> 현재 비밀번호</label>
      <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
    </div>
    <div class="mb-3">
      <label for="newPassword" class="form-label"><i class="fa-solid fa-lock-open"></i> 새 비밀번호</label>
      <input type="password" class="form-control" id="newPassword" name="newPassword" required>
    </div>
    <div class="mb-3">
      <label for="confirmPassword" class="form-label"><i class="fa-solid fa-check-double"></i> 새 비밀번호 확인</label>
      <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-primary"><i class="fa-solid fa-rotate"></i> 변경</button>
      <button type="button" class="btn btn-secondary" onclick="window.close()"><i class="fa-solid fa-xmark"></i> 닫기</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
