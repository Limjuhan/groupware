<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>차량 등록</title>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            max-width: 700px;
            margin-top: 60px;
        }
    </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
    <h4 class="mb-4 fw-bold">🚗 차량 등록</h4>

    <form:form action="insertVehicleByMng" method="post" modelAttribute="facilityFormDto">
        <!-- 모델명 -->
        <div class="mb-3">
            <form:input path="facName" cssClass="form-control" id="facName"/>
            <p style="color: red"><form:errors path="facName"/></p>
        </div>
        <!-- 차량번호 -->
        <div class="mb-3">
            <label for="facUid" class="form-label">차량번호</label>
            <form:input path="facUid" cssClass="form-control" id="facUid" placeholder="예: 12가1234"/>
            <p style="color: red"><form:errors path="facUid"/></p>
        </div>

        <!-- 수용인원 -->
        <div class="mb-4">
            <label for="capacity" class="form-label">수용인원</label>
            <form:input path="capacity" type="number" cssClass="form-control" id="capacity"/>
            <p style="color: red"><form:errors path="capacity"/></p>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a href="getVehicleManage" class="btn btn-outline-secondary">← 목록</a>
            <button type="submit" class="btn btn-primary">등록</button>
        </div>
    </form:form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
