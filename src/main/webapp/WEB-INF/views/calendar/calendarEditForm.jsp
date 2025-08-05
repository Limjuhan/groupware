<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일정 수정 - LDBSOFT</title>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 1000px;
            margin-top: 2rem;
        }

        .card {
            border-radius: 0.375rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
<div class="container">
    <div class="card p-4">
        <h3 class="mb-4 fw-bold">일정 수정</h3>

        <form:form method="post" modelAttribute="dto" action="updateCalendarByMng">
            <form:hidden path="scheduleId"/>

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
                <button type="submit" class="btn btn-primary btn-sm">수정</button>
                <a href="getCalendarList" class="btn btn-outline-secondary btn-sm">목록</a>
            </div>
        </form:form>
    </div>
</div>
</body>
</html>