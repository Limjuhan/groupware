<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>차량관리시스템 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">🚗 차량관리시스템</h2>
    <a href="roomRegisterForm" class="btn btn-primary">+ 차량 등록</a>
  </div>

  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>차량명</th>
        <th>차량번호</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>K0001</td><td>GN7</td><td>12가1234</td><td>5</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0001')">삭제하기</button></td>
      </tr>
      <tr>
        <td>K0002</td><td>CN7</td><td>34나5678</td><td>7</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0002')">삭제하기</button></td>
      </tr>
      <tr>
        <td>K0003</td><td>911</td><td>56다2345</td><td>9</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0003')">삭제하기</button></td>
      </tr>
      <tr>
        <td>K0004</td><td>530i</td><td>78라6789</td><td>2</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0004')">삭제하기</button></td>
      </tr>
      <tr>
        <td>K0005</td><td>macan</td><td>90마1111</td><td>5</td><td>N</td>
        <td>-</td>
      </tr>
      <tr>
        <td>K0006</td><td>bencz e-class</td><td>11바2222</td><td>7</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0006')">삭제하기</button></td>
      </tr>
      <tr>
        <td>K0007</td><td>avante ad</td><td>22사3333</td><td>5</td><td>Y</td>
        <td><button class="btn btn-outline-danger btn-sm" onclick="deleteCar('K0007')">삭제하기</button></td>
      </tr>
    </tbody>
  </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function deleteCar(carId) {
    if (confirm("차량 " + carId + "을(를) 삭제하시겠습니까?")) {
      // 여기에 실제 삭제 요청을 추가하면 됨 (예: location.href 또는 fetch)
      console.log("삭제 요청됨: " + carId);
      alert("삭제 완료 (예시)");
    }
  }
</script>

</body>
</html>
