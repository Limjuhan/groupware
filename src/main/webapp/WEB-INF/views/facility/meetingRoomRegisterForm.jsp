<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회의실 등록</title>
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 700px; margin-top: 60px; }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">🏢 회의실 등록</h4>

  <form:form action="insertMeetingRoomByMng" method="post" modelAttribute="facilityFormDto">

    <!-- 이름 -->
    <div class="mb-3">
      <label for="facName" class="form-label">이름</label>
      <form:input path="facName" cssClass="form-control" id="facName" placeholder="예: 중회의실 1"/>
      <p style="color: red"><form:errors path="facName"/></p>
    </div>

    <!-- 수용인원 -->
    <div class="mb-4">
      <label for="capacity" class="form-label">수용인원</label>
      <form:input path="capacity" type="number" cssClass="form-control" id="capacity"/>
      <p style="color: red"><form:errors path="capacity"/></p>
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="getMeetingRoomManage" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">등록</button>
    </div>
  </form:form>
</div>
</body>
</html>
