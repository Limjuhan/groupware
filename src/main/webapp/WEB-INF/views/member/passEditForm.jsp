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
      background: linear-gradient(135deg, #74ebd5, #acb6e5);
      font-family: 'Segoe UI', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .card-custom {
      background: rgba(255, 255, 255, 0.95);
      border-radius: 16px;
      padding: 30px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 450px;
    }

    .card-custom h4 {
      text-align: center;
      margin-bottom: 25px;
      font-weight: bold;
    }

    .form-control:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 5px rgba(13, 110, 253, 0.5);
    }

    .btn-custom {
      width: 100px;
    }

    .form-label i {
      margin-right: 6px;
      color: #0d6efd;
    }

    .btn-group {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }
  </style>
</head>
<body>

<div class="card-custom">
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
      <button type="submit" class="btn btn-primary btn-custom">변경</button>
      <button type="button" class="btn btn-secondary btn-custom" onclick="window.close()">닫기</button>
    </div>
  </form>
</div>

</body>
</html>
