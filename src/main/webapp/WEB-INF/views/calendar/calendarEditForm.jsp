<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>일정 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #1e1e1e;
            color: white;
        }

        .bg-glass {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(3px);
            -webkit-backdrop-filter: blur(3px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }

        label {
            font-weight: 500;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: #66afe9;
            outline: none;
            box-shadow: none;
        }

        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
        }

        .text-danger {
            font-size: 0.875em;
        }

        h3 {
            font-weight: bold;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.6);
        }
    </style>
</head>
<body>

<div class="container mt-5" style="max-width: 600px;">
    <div class="bg-glass">
        <h3 class="mb-4">✏️ 일정 수정</h3>

        <form:form method="post" modelAttribute="dto" action="updateCalendarByMng">
            <!-- scheduleId hidden -->
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
                <button type="submit" class="btn btn-primary">수정</button>
                <a href="getCalendarList" class="btn btn-secondary">목록</a>
            </div>
        </form:form>
    </div>
</div>

</body>
</html>
