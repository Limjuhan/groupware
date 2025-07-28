<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>예약내역 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1100px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">📋 내 예약내역</h2>

  <!-- 필터 & 검색 -->
  <form class="row g-2 mb-3" method="get" action="getReservationList">
    <div class="col-auto">
      <input type="month" class="form-control" name="yearMonth"  />
    </div>
    <div class="col-auto">
      <select class="form-select" name="facType">
        <option value="">전체유형</option>
        <option value="R_01" >차량</option>
        <option value="R_02" >회의실</option>
        <option value="R_03">비품</option>
      </select>
    </div>
    <div class="col-auto">
      <input type="text" class="form-control" name="keyword" placeholder="이름 또는 차종/회의실명 검색">
    </div>
    <div class="col-auto">
      <button class="btn btn-primary" type="submit">검색</button>
    </div>
  </form>

  <!-- 예약 리스트 -->
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>유형</th>
        <th>설비이름</th>
        <th>예약일</th>
        <th>예약기간</th>
        <th>취소</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach items="${facility}" var="f">
      <tr>
        <td>${f.facId}</td><td>${f.commName}</td><td>${f.facName}/${f.facUid}</td><td>${f.createdDate}</td><td>${f.startAt}~${f.endAt}</td>
          <td><button class="btn btn-outline-primary btn-sm" onclick="delReserve('${f.facId}')">취소</button></td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

</body>
</html>
