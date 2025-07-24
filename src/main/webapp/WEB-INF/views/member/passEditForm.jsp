<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    .error {
      color: red;
      font-size: 0.9em;
      margin-top: 5px;
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

  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
        ${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <form:form modelAttribute="dto" method="post" action="/member/UpdatePass" id="pwForm">
    <div class="mb-3">
      <label for="curPw" class="form-label"><i class="fa-solid fa-lock"></i> 현재 비밀번호</label>
      <form:password path="curPw" cssClass="form-control" id="curPw" required="true"/>
      <form:errors path="curPw" cssClass="error"/>
    </div>

    <div class="mb-3">
      <label for="newPw" class="form-label"><i class="fa-solid fa-lock-open"></i> 새 비밀번호</label>
      <form:password path="newPw" cssClass="form-control" id="newPw" required="true"/>
      <form:errors path="newPw" cssClass="error"/>
    </div>

    <div class="mb-3">
      <label for="chkPw" class="form-label"><i class="fa-solid fa-check-double"></i> 새 비밀번호 확인</label>
      <form:password path="chkPw" cssClass="form-control" id="chkPw" required="true"/>
      <form:errors path="chkPw" cssClass="error"/>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-primary"><i class="fa-solid fa-rotate"></i> 변경</button>
      <button type="button" class="btn btn-secondary" onclick="window.close()"><i class="fa-solid fa-xmark"></i> 닫기</button>
    </div>
  </form:form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 에러 발생한 첫 필드로 포커스 + 전체 선택
  document.addEventListener("DOMContentLoaded", function () {
    const fields = ["curPw", "newPw", "chkPw"];
    for (let id of fields) {
      const input = document.getElementById(id);
      const error = input?.nextElementSibling;
      if (error && error.classList.contains("error") && error.textContent.trim() !== "") {
        input.focus();
        input.select();
        break;
      }
    }
  });
</script>

</body>
</html>
