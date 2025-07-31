<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메뉴 등록 - LDBSOFT</title>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 1200px;
            margin-top: 2rem;
        }

        .card {
            border-radius: 0.375rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            font-weight: 500;
        }

        .form-control, .form-select, textarea {
            border-radius: 0.375rem;
        }

        .form-control:focus, .form-select:focus, textarea:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .btn {
            border-radius: 0.375rem;
        }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card p-4">
        <h3 class="mb-4 fw-bold">메뉴 등록</h3>

        <form:form modelAttribute="dto" method="post" action="insertMenu">
            <div class="mb-3">
                <label for="menuName" class="form-label">메뉴 이름</label>
                <form:input path="menuName" cssClass="form-control" placeholder="메뉴 이름을 입력하세요"/>
                <form:errors path="menuName" cssClass="text-danger"/>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">설명</label>
                <form:textarea path="description" cssClass="form-control" rows="4" placeholder="메뉴에 대한 설명을 입력하세요"/>
                <form:errors path="description" cssClass="text-danger"/>
            </div>

            <div class="mb-3">
                <label for="useYn" class="form-label">사용 여부</label>
                <form:select path="useYn" cssClass="form-select">
                    <form:option value="">선택하세요</form:option>
                    <form:option value="Y">사용</form:option>
                    <form:option value="N">미사용</form:option>
                </form:select>
                <form:errors path="useYn" cssClass="text-danger"/>
            </div>

            <div class="text-end">
                <button type="submit" class="btn btn-primary px-4">등록</button>
                <a href="/admin/getDeptAuthList" class="btn btn-outline-secondary px-4">목록으로</a>
            </div>
        </form:form>
    </div>
</div>
</body>
</html>