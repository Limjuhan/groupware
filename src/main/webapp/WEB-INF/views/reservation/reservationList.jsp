<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
  <form class="row g-2 mb-3">
    <div class="col-auto">
      <select class="form-select">
        <option selected>2025년</option>
        <option>2024년</option>
        <option>2023년</option>
      </select>
    </div>
    <div class="col-auto">
      <select class="form-select">
        <option selected>7월</option>
        <option>6월</option>
        <option>5월</option>
      </select>
    </div>
    <div class="col-auto">
      <input type="text" class="form-control" placeholder="이름 또는 차종/회의실명 검색">
    </div>
    <div class="col-auto">
      <button class="btn btn-primary" type="button">검색</button>
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
        <th>취소</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>K0002</td>
        <td>차량</td>
        <td>911 / 34나5678</td>
        <td>2025-07-15</td>
        <td><button class="btn btn-sm btn-outline-danger">취소</button></td>
      </tr>
      <tr>
        <td>R0002</td>
        <td>회의실</td>
        <td>대회의실</td>
        <td>2025-07-20</td>
        <td><button class="btn btn-sm btn-outline-danger">취소</button></td>
      </tr>
      <tr>
        <td>K0005</td>
        <td>차량</td>
        <td>macan / 90마1111</td>
        <td>2025-07-25</td>
        <td><button class="btn btn-sm btn-outline-danger">취소</button></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
