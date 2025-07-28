<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>품목 예약 신청</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 700px; margin-top: 60px; }

    /* 분 필드 숨김 */
    input[type="datetime-local"]::-webkit-datetime-edit-minute-field {
      display: none;
    }
    input[type="datetime-local"]::-webkit-clear-button,
    input[type="datetime-local"]::-webkit-inner-spin-button {
      display: none;
    }
    input[type="datetime-local"]::-webkit-calendar-picker-indicator {
      margin-left: 5px;
    }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">품목 예약 신청</h4>

  <form action="itemReservationProc" method="post">
    <!-- 품목코드 -->
    <div class="mb-3">
      <label class="form-label">공용설비ID</label>
      <input type="text" class="form-control" name="itemCode" value="P0001" readonly>
    </div>

    <!-- 품목명 -->
    <div class="mb-3">
      <label class="form-label">품목명</label>
      <input type="text" class="form-control" name="itemName" value="노트북" readonly>
    </div>

    <!-- 신청자명 -->
    <div class="mb-3">
      <label for="employeeName" class="form-label">신청자</label>
      <input type="text" class="form-control" id="employeeName" name="employeeName" required placeholder="이름 입력">
    </div>

    <!-- 시작일시 -->
    <div class="mb-3">
      <label for="startDatetime" class="form-label">시작일시</label>
      <input type="datetime-local" class="form-control" id="startDatetime" name="startDatetime"
             required step="3600" min="2025-01-01T09:00" max="2025-12-31T18:00">
    </div>

    <!-- 종료일시 -->
    <div class="mb-3">
      <label for="endDatetime" class="form-label">종료일시</label>
      <input type="datetime-local" class="form-control" id="endDatetime" name="endDatetime"
             required step="3600" min="2025-01-01T09:00" max="2025-12-31T18:00">
    </div>

    <!-- 대여 목적 -->
    <div class="mb-4">
      <label for="purpose" class="form-label">대여 목적</label>
      <textarea id="purpose" name="purpose" class="form-control" rows="4" required placeholder="사용 목적을 입력하세요."></textarea>
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="itemList" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">예약 신청</button>
    </div>
  </form>
</div>

<script>
  const startInput = document.getElementById("startDatetime");
  const endInput = document.getElementById("endDatetime");

  // 종료일시는 시작일시 이후부터만 선택 가능
  startInput.addEventListener("change", function () {
    endInput.min = this.value;
  });

  // 분을 강제로 00으로 설정
  document.querySelector("form").addEventListener("submit", function () {
    if (startInput.value) {
      startInput.value = startInput.value.substring(0, 13) + ":00";
    }
    if (endInput.value) {
      endInput.value = endInput.value.substring(0, 13) + ":00";
    }
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
