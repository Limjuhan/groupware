<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회의실관리 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">🏢 회의실관리</h2>
  <a href="meetingRoomRegisterForm" class="btn btn-primary" >+ 회의실 등록</a>
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>이름</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>R0001</td><td>중회의실 1</td><td>10</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('R0001')">삭제하기</button></td>
      </tr>
      <tr>
        <td>R0002</td><td>대회의실</td><td>20</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('R0002')">삭제하기</button></td>
      </tr>
      <tr>
        <td>R0003</td><td>소회의실 A</td><td>6</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('R0003')">삭제하기</button></td>
      </tr>
      <tr>
        <td>R0004</td><td>소회의실 B</td><td>8</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('R0004')">삭제하기</button></td>
      </tr>
      <tr>
        <td>R0005</td><td>프로젝트룸</td><td>12</td><td>N</td>
        <td>-</td>
      </tr>
    </tbody>
  </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function confirmDelete(roomId) {
    if (confirm(roomId + " 회의실을 삭제하시겠습니까?")) {
      alert("삭제되었습니다. (예시)");
      // 실제 삭제 처리 로직 추가 가능
    }
  }
</script>
</body>
</html>
