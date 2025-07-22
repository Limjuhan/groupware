<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>일정 리스트</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 1000px;
      margin-top: 50px;
    }
    .table td, .table th {
      vertical-align: middle;
    }
    .btn + .btn {
      margin-left: 5px;
    }
  </style>
</head>
<body>
  <div class="container bg-white p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold">📋 일정 목록</h3>
      <a href="getCalendarForm" class="btn btn-primary">+ 일정 등록</a>
    </div>

    <table class="table table-bordered align-middle text-center">
      <thead class="table-light">
        <tr>
          <th>제목</th>
          <th>시작일</th>
          <th>종료일</th>
          <th>내용</th>
          <th>기능</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>프로젝트 A 시작</td>
          <td>2025-07-10</td>
          <td>2025-07-15</td>
          <td>프로젝트 A를 본격적으로 시작합니다.</td>
          <td>
            <a href="scheduleEdit.jsp?id=1" class="btn btn-sm btn-warning">수정</a>
            <button class="btn btn-sm btn-danger">삭제</button>
          </td>
        </tr>
        <tr>
          <td>전체 회의</td>
          <td>2025-07-12</td>
          <td>-</td>
          <td>부서 전체 회의가 진행됩니다.</td>
          <td>
            <a href="scheduleEdit.jsp?id=2" class="btn btn-sm btn-warning">수정</a>
            <button class="btn btn-sm btn-danger">삭제</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</body>
</html>
