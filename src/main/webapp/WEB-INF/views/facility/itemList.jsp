<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비품리스트</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 960px;
      margin-top: 50px;
    }
    .table th, .table td {
      vertical-align: middle;
      text-align: center;
    }
    tbody tr {
      transition: background-color 0.2s;
    }
    tbody tr:hover {
      cursor: pointer;
      background-color: #e7f1ff;
    }
    .search-form .form-control,
    .search-form .form-select {
      height: 100%;
    }
    .search-form .form-label {
      font-weight: 500;
    }
    .search-form {
      margin-bottom: 40px;
    }
  </style>
</head>
<body>
<div class="container">
  <h3 class="mb-4 fw-bold" style="color: white">비품 리스트</h3>

  <!-- 검색 및 필터 폼 -->
  <form class="row align-items-end g-3 search-form" method="get" style="color: white;" action="getItemList">
    <div class="col-md-6">
      <label for="keyword" class="form-label">비품명</label>
      <input type="text" id="keyword" class="form-control" name="keyword" placeholder="예: 노트북">
    </div>
    <div class="col-md-3">
      <label for="rentYn" class="form-label">반납여부</label>
      <select name="rentYn" id="rentYn" class="form-select">
        <option value="">전체</option>
        <option value="Y">Y</option>
        <option value="N">N</option>
      </select>
    </div>
    <div class="col-md-3">
      <label class="form-label d-block">&nbsp;</label>
      <button type="submit" class="btn btn-outline-primary w-100">검색</button>
    </div>
  </form>

  <!-- 품목 리스트 -->
  <table class="table table-bordered table-hover bg-white">
    <thead class="table-light">
      <tr>
        <th>공용설비ID</th>
        <th>이름</th>
        <th>식별번호</th>
        <th>수용인원</th>
        <th>반납여부</th>
        <th>예약</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach items="${facility}" var="item">
      <tr>
        <td>${item.facId}</td><td>${item.facName}</td><td>${item.facUid}</td><td>${item.capacity}</td><td>${item.rentYn}</td>
        <c:if test="${item.rentYn eq 'Y'}">
          <td><button class="btn btn-outline-primary btn-sm" onclick="openModal('${item.facId}', '${item.facName}')">예약하기</button></td>
        </c:if>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <!-- 페이징 -->

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
<div class="modal fade" id="reserveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">비품 예약</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="reserveForm" action="insertFacilityRent" method="post">
          <input type="hidden" name="startAt" id="startAt">
          <input type="hidden" name="endAt" id="endAt">
          <input type="hidden" name="rentalPurpose" id="rentalPurpose">
          <input type="hidden" name="facId" id="facId" >
          <input type="hidden" name="renterId" value="${sessionScope.loginId}"> <%-- 세션으로변경해야함--%>
        </form>

        <p id="reserveInfo" ></p>
        <!-- 시작일 -->
        <label class="form-label">시작일</label>
        <input type="date" class="form-control mb-2" id="startDate">

        <!-- 시작시간 (직접입력) -->
        <label class="form-label">시작시간 (0~23)</label>
        <input type="number" class="form-control mb-3" id="startHour" min="0" max="23" placeholder="예: 9">

        <!-- 종료일 -->
        <label class="form-label">종료일</label>
        <input type="date" class="form-control mb-2" id="endDate">

        <!-- 종료시간 (직접입력) -->
        <label class="form-label">종료시간 (0~23)</label>
        <input type="number" class="form-control mb-3" id="endHour" min="0" max="23" placeholder="예: 18">

        <!-- 대여 목적 -->
        <label class="form-label">대여 목적</label>
        <input type="text" class="form-control" id="purpose">
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
    var startDate = document.getElementById("startDate").value;
    var startHour = document.getElementById("startHour").value;
    var endDate = document.getElementById("endDate").value;
    var endHour = document.getElementById("endHour").value;
    var purpose = document.getElementById("purpose").value.trim();

    if (!startDate || !endDate || startHour === "" || endHour === "" || purpose === "") {
      alert("모든 정보를 입력해주세요.");
      return;
    }


    const start = new Date(startDate + "T" + startHour.padStart(2, "0") + ":00:00");
    const end = new Date(endDate + "T" + endHour.padStart(2, "0") + ":00:00");

    if (start >= end) {
      alert("시작일시가 종료일시보다 같거나 늦을 수 없습니다.");
      return;
    }

    console.log("예약 시작: " + start);
    console.log("예약 종료: " + end);
    console.log("목적: " + purpose);

    document.getElementById("startAt").value = start;
    document.getElementById("endAt").value = end;
    document.getElementById("rentalPurpose").value = purpose;

    document.getElementById("reserveForm").submit(); // 폼 전송
    // 이후 서버로 전송하거나 form에 값 넣기
  });
</script>

<script>
  function openModal(id, model , type) {
    document.getElementById('reserveInfo').innerText = '공용설비ID: ' + id + ' / 비품명: ' + model;
    const modal = new bootstrap.Modal(document.getElementById('reserveModal'));
    document.querySelector("#facId").value = id; //form에 fac_id값전송
    modal.show();
  }
</script>

</body>
</html>
