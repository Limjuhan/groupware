<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>차량예약리스트 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">🚗 차량예약리스트</h2>
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>차량명</th>
        <th>차량번호</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>예약</th>
      </tr>
    </thead>
    <tbody>
      <!-- 차량목록 하드코딩 -->
      <tr>
        <td>K0001</td><td>GN7</td><td>12가1234</td><td>5</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0001', 'GN7')">예약하기</button></td>
      </tr>
      <tr>
        <td>K0002</td><td>CN7</td><td>34나5678</td><td>7</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0002', 'CN7')">예약하기</button></td>
      </tr>
      <tr>
        <td>K0003</td><td>911</td><td>56다2345</td><td>9</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0003', '911')">예약하기</button></td>
      </tr>
      <tr>
        <td>K0004</td><td>530i</td><td>78라6789</td><td>2</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0004', '530i')">예약하기</button></td>
      </tr>
      <tr>
        <td>K0005</td><td>macan</td><td>90마1111</td><td>5</td><td>N</td>
        <td>-</td>
      </tr>
      <tr>
        <td>K0006</td><td>bencz e-class</td><td>11바2222</td><td>7</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0006', 'bencz e-class')">예약하기</button></td>
      </tr>
      <tr>
        <td>K0007</td><td>avante ad</td><td>22사3333</td><td>5</td><td>Y</td>
        <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('K0007', 'avante ad')">예약하기</button></td>
      </tr>
    </tbody>
  </table>
</div>

<div class="modal fade" id="reserveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">차량 예약</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p id="reserveInfo"></p>

        <!-- 시작일 -->
        <label class="form-label">시작일</label>
        <input type="date" class="form-control mb-2" id="carStartDate">

        <!-- 시작시간 (직접입력) -->
        <label class="form-label">시작시간 (0~23)</label>
        <input type="number" class="form-control mb-3" id="carStartHour" min="0" max="23" placeholder="예: 9">

        <!-- 종료일 -->
        <label class="form-label">종료일</label>
        <input type="date" class="form-control mb-2" id="carEndDate">

        <!-- 종료시간 (직접입력) -->
        <label class="form-label">종료시간 (0~23)</label>
        <input type="number" class="form-control mb-3" id="carEndHour" min="0" max="23" placeholder="예: 18">

        <!-- 대여 목적 -->
        <label class="form-label">대여 목적</label>
        <input type="text" class="form-control" id="carPurpose">
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button class="btn btn-primary" id="reserveBtn">예약</button>
      </div>
    </div>
  </div>
</div>

<script>
  document.getElementById("reserveBtn").addEventListener("click", function () {
    var startDate = document.getElementById("carStartDate").value;
    var startHour = document.getElementById("carStartHour").value;
    var endDate = document.getElementById("carEndDate").value;
    var endHour = document.getElementById("carEndHour").value;
    var purpose = document.getElementById("carPurpose").value.trim();

    if (!startDate || !endDate || startHour === "" || endHour === "" || purpose === "") {
      alert("모든 정보를 입력해주세요.");
      return;
    }

    var formattedStart = startDate + "T" + (startHour.length == 1 ? "0" + startHour : startHour) + ":00";
    var formattedEnd = endDate + "T" + (endHour.length == 1 ? "0" + endHour : endHour) + ":00";

    console.log("예약 시작: " + formattedStart);
    console.log("예약 종료: " + formattedEnd);
    console.log("목적: " + purpose);

    // 이후 서버로 전송하거나 form에 값 넣기
  });
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function openModal(id, model) {
    document.getElementById('reserveInfo').innerText = '차량번호: ' + id + ' / 차량명: ' + model;
    const modal = new bootstrap.Modal(document.getElementById('reserveModal'));
    modal.show();
  }
</script>
</body>
</html>
