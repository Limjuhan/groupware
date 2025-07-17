<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회의실 등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 700px; margin-top: 60px; }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">🏢 회의실 등록</h4>

  <form action="roomRegisterProc.jsp" method="post">
    <!-- 설비번호 -->
    <div class="mb-3">
      <label for="roomId" class="form-label">공용설비ID</label>
      <input type="text" class="form-control" id="roomId" name="roomId" required placeholder="예: R0001">
    </div>

    <!-- 이름 -->
    <div class="mb-3">
      <label for="roomName" class="form-label">이름</label>
      <input type="text" class="form-control" id="roomName" name="roomName" required placeholder="예: 중회의실 1">
    </div>

    <!-- 수용인원 -->
    <div class="mb-4">
      <label for="capacity" class="form-label">수용인원</label>
      <input type="number" class="form-control" id="capacity" name="capacity" required min="1" max="100" value="1">
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="roomList.jsp" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">등록</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
