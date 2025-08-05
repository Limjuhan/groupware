<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품 등록</title>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            max-width: 600px;
            margin-top: 60px;
        }
    </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
    <h4 class="mb-4 fw-bold">🖥 비품 등록</h4>

    <form:form action="insertItemByMng" method="post" modelAttribute="facilityFormDto">
        <!-- 품목명 -->
        <div class="mb-3">
            <label for="facName" class="form-label">비품명</label>
            <form:input path="facName" cssClass="form-control" id="facName" placeholder="예: 노트북"/>
            <p style="color: red"><form:errors path="facName"/></p>
        </div>

        <!-- 수용인원: 비품은 기본 1 -->
        <form:hidden path="capacity" value="1"/>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a href="getItemManage" class="btn btn-outline-secondary">← 목록</a>
            <button type="submit" class="btn btn-primary">등록</button>
        </div>
    </form:form>
</div>
</body>
</html>
