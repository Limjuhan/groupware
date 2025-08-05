<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>에러 발생</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: url('/img/sad.jpg') center center / cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .glass-box {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(2px);
            -webkit-backdrop-filter: blur(2px);
            border-radius: 0.75rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 40px;
            max-width: 600px;
            width: 100%;
            color: #fff;
            box-shadow: 0 0 30px rgba(0,0,0,0.2);
        }

        .glass-box h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .glass-box p.lead {
            font-size: 1.2rem;
        }

        .glass-box hr {
            border-top: 1px solid rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>

<div class="glass-box text-center">
    <h1 class="text-danger"><i class="fa-solid fa-triangle-exclamation"></i> 에러 발생</h1>
    <p class="lead">
        요청 처리 중 문제가 발생했습니다.<br>
        관리자에게 문의하세요.
    </p>
    <hr>
    <p><strong><i class="fa-solid fa-bug"></i> 에러 메시지:</strong> <%= exception != null ? exception.getMessage() : "알 수 없는 오류" %></p>
    <a href="/" class="btn btn-outline-light mt-3">
        <i class="fa-solid fa-arrow-left"></i> 홈으로 돌아가기
    </a>
</div>

</body>
</html>
