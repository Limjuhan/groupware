<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일정 등록 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .form-control {
            border-radius: 0.375rem;
        }

        .form-control:focus {
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
    <h2 class="page-title">일정 등록</h2>

    <form:form method="post" modelAttribute="dto" action="insertCalendarByMng">
        <div class="mb-3">
            <label for="scheduleTitle" class="form-label">제목</label>
            <form:input path="scheduleTitle" cssClass="form-control" id="scheduleTitle"/>
            <form:errors path="scheduleTitle" cssClass="text-danger"/>
        </div>

        <div class="mb-3">
            <label for="scheduleContent" class="form-label">내용</label>
            <form:textarea path="scheduleContent" cssClass="form-control" rows="3" id="scheduleContent"/>
            <form:errors path="scheduleContent" cssClass="text-danger"/>
        </div>

        <div class="mb-3">
            <label for="startAt" class="form-label">시작일시</label>
            <form:input path="startAt" cssClass="form-control" id="startAt" type="datetime-local"/>
            <form:errors path="startAt" cssClass="text-danger"/>
        </div>

        <div class="mb-3">
            <label for="endAt" class="form-label">종료일시</label>
            <form:input path="endAt" cssClass="form-control" id="endAt" type="datetime-local"/>
            <form:errors path="endAt" cssClass="text-danger"/>
            <c:if test="${not empty dateError}">
                <div class="text-danger">${dateError}</div>
            </c:if>
        </div>

        <div class="text-end">
            <a href="/calendar/getCalendarList" class="btn btn-outline-secondary btn-sm">목록</a>
            <button type="submit" class="btn btn-primary btn-sm">등록</button>
            <button type="reset" class="btn btn-outline-secondary btn-sm">초기화</button>
        </div>
    </form:form>
</div>
</body>
</html>