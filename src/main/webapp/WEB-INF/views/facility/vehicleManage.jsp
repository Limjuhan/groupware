<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>차량 관리 - LDBSOFT 그룹웨어</title>
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-0">🚗 차량관리시스템</h2>
    <!-- 검색 및 필터 폼 -->
    <form class="mb-4" method="get" action="getVehicleManage">
        <input type="hidden" name="manage" value="manage">

        <div class="row mb-3 align-items-end g-2">
            <!-- 차량명/공용설비ID -->
            <div class="col-md-5">
                <label for="keyword" class="form-label fw-medium">차량명 / 공용설비ID</label>
                <input type="text" id="keyword" name="keyword" class="form-control"
                       placeholder="예: G70 또는 f002" value="${param.keyword}">
            </div>

            <!-- 반납 여부 -->
            <div class="col-md-3">
                <label for="rentYn" class="form-label fw-medium">반납 여부</label>
                <select name="rentYn" id="rentYn" class="form-select">
                    <option value="">전체</option>
                    <option value="Y" ${param.rentYn == 'Y' ? 'selected' : ''}>Y</option>
                    <option value="N" ${param.rentYn == 'N' ? 'selected' : ''}>N</option>
                </select>
            </div>

            <!-- 검색 버튼 -->
            <div class="col-md-2">
                <label class="form-label fw-medium d-block">&nbsp;</label>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
                </button>
            </div>

            <!-- 등록 버튼 -->
            <div class="col-md-2">
                <label class="form-label fw-medium d-block">&nbsp;</label>
                <a href="getVehicleForm" class="btn btn-success w-100">
                    <i class="fa-solid fa-plus me-1"></i> 차량 등록
                </a>
            </div>
        </div>
    </form>
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
    <tr>
      <th>공용설비ID</th>
      <th>이름</th>
      <th>차량번호</th>
      <th>수용인원</th>
      <th>반납여부</th>
      <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${facility}" var="c">
      <tr>
        <td>${c.facId}</td><td>${c.facName}</td><td>${c.facUid}</td><td>${c.capacity}</td><td>${c.rentYn}</td>
        <td>
          <c:if test="${c.rentYn=='Y'}">
          <button class="btn btn-outline-danger btn-sm" onclick="confirmDelete('${c.facId}','${c.facName}','${c.facType}')">삭제하기</button></td>
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
  function confirmDelete(carId,carName,facType) {
    if (confirm(carName + "("+carId+") 차량을 삭제하시겠습니까?")) {
      location.href = "deleteFacilityByMng?facId="+carId+"&facType="+facType;
    }
  }
</script>
</body>
</html>
