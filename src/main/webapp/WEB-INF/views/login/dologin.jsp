<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LDBSOFT 그룹웨어 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            background:
                    linear-gradient(135deg, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)),
                    url('/img/won3.jpg') center center / cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.01);
            color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            border: 1px solid rgba(255,255,255,0.2);
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
        }

        .brand-title {
            font-size: 24px;
            font-weight: bold;
            color: #ffffff;
        }

        .form-label {
            color: #ffffff;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.1);
            border: none;
            color: #ffffff;
        }

        .form-control::placeholder {
            color: #cccccc;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.015);
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
            color: #ffffff;
        }

        /* ✅ 로그인 버튼 - 파란색 반투명 배경 + 파란 텍스트 */
        .btn-login {
            background-color: rgba(13, 110, 253, 0.01); /* 연한 반투명 파란색 */
            border: 1px solid rgba(13, 110, 253, 0.4);
            color: #0d6efd;
            font-weight: bold;
        }

        .btn-login:hover {
            background-color: rgba(13, 110, 253, 0.2);
            border-color: #0a58ca;
            color: #0a58ca;
        }

        .footer {
            margin-top: 20px;
            font-size: 0.9rem;
            color: #eeeeee;
            text-align: center;
        }

        .text-decoration-none {
            text-decoration: none !important;
        }

        .underline-text {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="text-center mb-4">
        <div class="brand-title mb-2">LDBSOFT Groupware</div>
        <p class="text-light">스마트한 업무, 효율적인 협업</p>
    </div>
    <form action="loginProcess" method="post">
        <div class="mb-3">
            <label for="id" class="form-label">아이디</label>
            <input type="text" class="form-control" id="id" name="id" required autofocus
                   placeholder="사원번호를 입력해주세요">
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="password" name="password" required
                   placeholder="비밀번호를 입력해주세요">
        </div>

        <div class="d-grid gap-2 mb-3">
            <button type="submit" class="btn btn-login btn-lg">로그인하기</button>
        </div>

        <div class="text-center mt-3">
            <a href="findPass" class="text-decoration-none text-light">
                비밀번호를 잃어버리셨나요? <span class="underline-text"><strong>비밀번호 찾기</strong></span>
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
