<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>일정 등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f4f6f9;
    }
    .container {
      max-width: 600px;
      margin-top: 60px;
      background: white;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h3 {
      font-weight: bold;
    }
  </style>
</head>
<body>
  <div class="container">
    <h3 class="mb-4">📅 일정 등록</h3>
    <form>
      <div class="mb-3">
        <label for="eventTitle" class="form-label">제목</label>
        <input type="text" class="form-control" id="eventTitle" name="title" required>
      </div>
      <div class="mb-3">
        <label for="eventContent" class="form-label">내용</label>
        <textarea class="form-control" id="eventContent" name="content" rows="3"></textarea>
      </div>
      <div class="mb-3">
        <label for="eventStart" class="form-label">시작일</label>
        <input type="date" class="form-control" id="eventStart" name="startDate" required>
      </div>
      <div class="mb-3">
        <label for="eventEnd" class="form-label">종료일</label>
        <input type="date" class="form-control" id="eventEnd" name="endDate">
      </div>
      <div class="text-end">
        <button type="submit" class="btn btn-primary">등록</button>
        <button type="reset" class="btn btn-secondary">취소</button>
      </div>
    </form>
  </div>
</body>
</html>
