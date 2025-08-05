<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa; /* 밝은 회색 배경 */
        }

        .container {
            max-width: 400px;
        }

        .card {
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }

        .form-label {
            font-weight: 500;
        }

        .form-control {
            border-radius: 0.3rem;
        }

        .btn {
            border-radius: 0.3rem;
        }

        .error {
            color: #dc3545;
            font-size: 0.9em;
            margin-top: 5px;
        }
    </style>
</head>
<body class="bg-light d-flex justify-content-center align-items-center" style="height: 100vh;">

<div class="container">
    <div class="card p-4">
        <h2 class="mb-4 fw-bold text-center">비밀번호 변경</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
                    ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form:form modelAttribute="dto" method="post" action="updatePass" id="pwForm">
            <div class="mb-3">
                <label for="curPw" class="form-label">현재 비밀번호</label>
                <form:password path="curPw" cssClass="form-control" id="curPw" required="true"/>
                <form:errors path="curPw" cssClass="error"/>
            </div>

            <div class="mb-3">
                <label for="newPw" class="form-label">새 비밀번호</label>
                <form:password path="newPw" cssClass="form-control" id="newPw" required="true"/>
                <form:errors path="newPw" cssClass="error"/>
            </div>

            <div class="mb-3">
                <label for="chkPw" class="form-label">새 비밀번호 확인</label>
                <form:password path="chkPw" cssClass="form-control" id="chkPw" required="true"/>
                <form:errors path="chkPw" cssClass="error"/>
            </div>

            <div class="text-end mt-4">
                <button type="submit" class="btn btn-primary me-2">변경</button>
                <button type="button" class="btn btn-outline-secondary" onclick="window.close()">닫기</button>
            </div>
        </form:form>
    </div>
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