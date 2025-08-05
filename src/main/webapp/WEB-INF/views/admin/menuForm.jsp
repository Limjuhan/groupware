<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메뉴 등록 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        /* 공통 컨텐츠 영역 */
        .page-content {
            width: 100%;
            min-height: calc(100vh - 160px);
            display: flex;
            flex-direction: column;
            background-color: #fff;
            padding: 20px;
            box-sizing: border-box;
        }

        /* 페이지 제목 */
        .page-title {
            margin-bottom: 20px;
            font-weight: bold;
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
<div class="page-content">
    <h2 class="page-title">메뉴 등록</h2>

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
</body>
</html>