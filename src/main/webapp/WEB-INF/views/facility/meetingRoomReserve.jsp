<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회의실 예약 신청</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 700px; margin-top: 60px; }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">회의실 예약 신청</h4>

  <form action="meetingRoomReserveProc.jsp" method="post">
    <!-- 공용설비ID -->
    <div class="mb-3">
      <label class="form-label">공용설비ID</label>
      <input type="text" class="form-control" name="roomId" value="R0001" readonly>
    </div>

    <!-- 이름 -->
    <div class="mb-3">
      <label class="form-label">회의실 이름</label>
      <input type="text" class="form-control" name="roomName" value="중회의실 1" readonly>
    </div>

    <!-- 수용인원 -->
    <div class="mb-3">
      <label class="form-label">수용인원</label>
      <input type="number" class="form-control" name="capacity" value="10" readonly>
    </div>

    <!-- 시작일자 / 시간 -->
    <div class="mb-3">
      <label class="form-label">시작일자</label>
      <input type="date" class="form-control" name="startDate" required>
    </div>
    <div class="mb-3">
      <label class="form-label">시작시간 (0~23)</label>
      <input type="number" class="form-control" name="startHour" min="0" max="23" required>
    </div>

    <!-- 종료일자 / 시간 -->
    <div class="mb-3">
      <label class="form-label">종료일자</label>
      <input type="date" class="form-control" name="endDate" required>
    </div>
    <div class="mb-3">
      <label class="form-label">종료시간 (0~23)</label>
      <input type="number" class="form-control" name="endHour" min="0" max="23" required>
    </div>

    <!-- 대여 목적 -->
    <div class="mb-4">
      <label class="form-label">대여 목적</label>
      <textarea class="form-control" name="purpose" rows="4" required></textarea>
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="meetingRoomList" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">예약 신청</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
