<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <!-- 검색 및 필터 폼 -->
  <form class="row g-2 align-items-center mb-4" method="get" action="getMeetingRoomManage">
    <!-- 비품명 검색 -->
    <div class="col-md-5">
      <div class="form-floating">
        <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 회의실205호">
        <label for="keyword">이름/공용설비ID</label>
      </div>
    </div>

    <!-- 반납 여부 -->
    <div class="col-md-3">
      <div class="form-floating">
        <select name="rentYn" id="rentYn" class="form-select">
          <option value="">전체</option>
          <option value="Y">Y</option>
          <option value="N">N</option>
        </select>
        <label for="rentYn">반납여부</label>
      </div>
    </div>

    <!-- 검색 버튼 -->
    <div class="col-md-2 d-grid">
      <button type="submit" class="btn btn-primary">
        <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
      </button>
    </div>
  </form>
  <a href="getMeetingRoomForm" class="btn btn-primary" >+ 회의실 등록</a>
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>이름</th>
        <th>식별번호</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach items="${meetingRooms}" var="m">
      <tr>
        <td>${m.facId}</td><td>${m.facName}</td><td>${m.facUid}</td><td>${m.capacity}</td><td>${m.rentYn}</td>
        <td>
          <c:if test="${m.rentYn=='Y'}">
            <button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('${m.facId}','${m.facName}','${m.facType}')">삭제하기</button></td>
          </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <nav class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item">
        <a class="page-link" href="?page=${pageDto.page - 1}">이전</a>
      </li>
      <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="p">
        <li class="page-item ">
          <a class="page-link" href="?page=${p}">${p}</a>
        </li>
      </c:forEach>
      <li class="page-item">
        <a class="page-link" href="?page=${pageDto.page+1}">다음</a>
      </li>
    </ul>
  </nav>
</div>
<script>
  function confirmDelete(roomId,roomName,facType) {
    if (confirm(roomName + "("+roomId+") 회의실을 삭제하시겠습니까?")) {
     location.href = "deleteFacilityByMng?facId="+roomId+"&facType="+facType;
    }
  }
</script>
</body>
</html>
