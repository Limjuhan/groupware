<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메뉴 등록 - LDBSOFT</title>

    <style>
        body {
            background-color: #1e1e1e;
            color: white;
        }

        .form-wrapper {
            max-width: 800px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 30px;
            border-radius: 0.75rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 0.5rem;
        }

        .form-control, select, textarea {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .form-control:focus, select:focus, textarea:focus {
            background-color: rgba(255, 255, 255, 0.05) !important;
            border-color: #0d6efd;
            color: white !important;
        }

        select option {
            background-color: #1e1e1e;
            color: white;
        }

        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
        }

        label {
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="form-wrapper shadow">
    <div class="form-title">메뉴 등록</div>

    <!-- 메뉴 등록 폼 -->
    <form:form modelAttribute="dto" method="post" action="insertMenu">
        <!-- 메뉴 이름 -->
        <div class="mb-3">
            <label for="menuName" class="form-label">메뉴 이름</label>
            <form:input path="menuName" cssClass="form-control" placeholder="메뉴 이름을 입력하세요"/>
            <form:errors path="menuName" cssClass="text-danger small"/>
        </div>

        <!-- 설명 -->
        <div class="mb-3">
            <label for="description" class="form-label">설명</label>
            <form:textarea path="description" cssClass="form-control" rows="4" placeholder="메뉴에 대한 설명을 입력하세요"/>
            <form:errors path="description" cssClass="text-danger small"/>
        </div>

        <!-- 사용 여부 -->
        <div class="mb-3">
            <label for="useYn" class="form-label">사용 여부</label>
            <form:select path="useYn" cssClass="form-select">
                <form:option value="">선택하세요</form:option>
                <form:option value="Y">사용</form:option>
                <form:option value="N">미사용</form:option>
            </form:select>
            <form:errors path="useYn" cssClass="text-danger small"/>
        </div>

        <!-- 버튼 -->
        <div class="text-end">
            <button type="submit" class="btn btn-primary px-4">등록</button>
            <a href="/admin/getDeptAuthList" class="btn btn-secondary px-4">목록으로</a>
        </div>
    </form:form>
</div>

</body>
</html>
