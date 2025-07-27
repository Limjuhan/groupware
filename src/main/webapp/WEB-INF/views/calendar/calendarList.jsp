<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>일정 관리</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 1000px; margin-top: 50px; }
    .table td, .table th { vertical-align: middle; }
    .btn + .btn { margin-left: 5px; }
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
    <c:forEach var="s" items="${scheduleList}">
      <tr>
        <td>${s.scheduleTitle}</td>
        <td><fmt:formatDate value="${s.startAt}" pattern="yyyy-MM-dd"/></td>
        <td><fmt:formatDate value="${s.endAt}" pattern="yyyy-MM-dd"/></td>
        <td>${s.scheduleContent}</td>
        <td>
          <a href="getCalendarForm?scheduleId=${s.scheduleId}" class="btn btn-sm btn-warning">수정</a>
          <a href="deleteSchedule?scheduleId=${s.scheduleId}" class="btn btn-sm btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty scheduleList}">
      <tr>
        <td colspan="5" class="text-center text-muted">등록된 일정이 없습니다.</td>
      </tr>
    </c:if>
    </tbody>
  </table>

  <div class="d-flex justify-content-center mt-3">
    <nav>
      <ul class="pagination pagination-sm">
        <c:if test="${pageDto.page > 1}">
          <li class="page-item">
            <a class="page-link" href="getCalendarList?page=1">&laquo;&laquo;</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="getCalendarList?page=${pageDto.page - 1}">&laquo;</a>
          </li>
        </c:if>
        <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="i">
          <li class="page-item ${pageDto.page == i ? 'active' : ''}">
            <a class="page-link" href="getCalendarList?page=${i}">${i}</a>
          </li>
        </c:forEach>
        <c:if test="${pageDto.page < pageDto.totalPages}">
          <li class="page-item">
            <a class="page-link" href="getCalendarList?page=${pageDto.page + 1}">&raquo;</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="getCalendarList?page=${pageDto.totalPages}">&raquo;&raquo;</a>
          </li>
        </c:if>
      </ul>
    </nav>
  </div>
</div>
</body>
</html>
