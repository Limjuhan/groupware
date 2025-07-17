<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회의실 예약리스트 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">🏢 회의실 리스트</h2>
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>이름</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>예약</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>R0001</td><td>중회의실 1</td><td>10</td><td>Y</td>
        <td><a href="meetingRoomReserve?roomId=R0001" class="btn btn-outline-primary btn-sm">예약하기</a></td>
      </tr>
      <tr>
        <td>R0002</td><td>대회의실</td><td>20</td><td>Y</td>
        <td><a href="meetingRoomReserve?roomId=R0002" class="btn btn-outline-primary btn-sm">예약하기</a></td>
      </tr>
      <tr>
        <td>R0003</td><td>소회의실 A</td><td>6</td><td>Y</td>
        <td><a href="meetingRoomReserve?roomId=R0003" class="btn btn-outline-primary btn-sm">예약하기</a></td>
      </tr>
      <tr>
        <td>R0004</td><td>소회의실 B</td><td>8</td><td>Y</td>
        <td><a href="meetingRoomReserve?roomId=R0004" class="btn btn-outline-primary btn-sm">예약하기</a></td>
      </tr>
      <tr>
        <td>R0005</td><td>프로젝트룸</td><td>12</td><td>N</td>
        <td>-</td>
      </tr>
    </tbody>
  </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
