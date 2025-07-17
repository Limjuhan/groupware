<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LDBSOFT 그룹웨어 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0d1b2a, #1b263b);
            height: 100vh;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background-color: #ffffff;
            color: #000;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
        }

        .login-card h3 {
            color: #1b263b;
        }

        .brand-title {
            font-size: 24px;
            font-weight: bold;
            color: #0d6efd;
        }

        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }

        .footer {
            margin-top: 20px;
            font-size: 0.9rem;
            color: #adb5bd;
            text-align: center;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="text-center mb-4">
            <div class="brand-title">LDBSOFT Groupware</div>
            <p class="text-muted">스마트한 업무, 효율적인 협업</p>
        </div>
        <form action="loginProcess" method="post">
    <div class="mb-3">
        <label for="username" class="form-label">아이디</label>
        <input type="text" class="form-control" id="username" name="username" required autofocus>
    </div>
    <div class="mb-3">
        <label for="password" class="form-label">비밀번호</label>
        <input type="password" class="form-control" id="password" name="password" required>
    </div>
    
    <div class="d-flex justify-content-between align-items-center">
        <button type="submit" class="btn btn-primary w-50">로그인</button>
        <a href="findPass" class="btn btn-outline-secondary ms-2 w-50" style="white-space: nowrap;">
            비밀번호 찾기
        </a>
    </div>
</form>

        <div class="footer mt-4">
            ⓒ 2025 LDBSOFT. All rights reserved.
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
