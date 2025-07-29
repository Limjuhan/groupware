<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>예약내역 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1100px; margin-top: 40px; }
    .table td, .table th { vertical-align: middle; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">📋 내 예약내역</h2>

  <!-- 필터 & 검색 -->
  <form class="row g-2 mb-3" method="get" action="getReservationList">
    <div class="col-auto">
      <input type="month" class="form-control" name="yearMonth" value="${param.yearMonth}" />
    </div>
    <div class="col-auto">
      <select class="form-select" name="facType">
        <option value="">전체유형</option>
        <option value="R_01" <c:if test="${param.facType == 'R_01'}">selected</c:if>>차량</option>
        <option value="R_02" <c:if test="${param.facType == 'R_02'}">selected</c:if>>회의실</option>
        <option value="R_03" <c:if test="${param.facType == 'R_03'}">selected</c:if>>비품</option>
      </select>
    </div>
    <div class="col-auto">
      <input type="text" class="form-control" name="keyword" placeholder="이름 또는 차종/회의실명 검색" value="${param.keyword}" />
    </div>
    <div class="col-auto form-check align-self-center">
      <input type="checkbox" name="includeCancel" value="true"
             <c:if test="${param.includeCancel == 'true'}">checked</c:if>>
      <label class="form-check-label" for="cancelCheck">취소 포함</label>
    </div>
    <div class="col-auto">
      <button class="btn btn-primary" type="submit">검색</button>
    </div>
  </form>

  <!-- 예약 리스트 -->
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
    <tr>
      <th>공용설비ID</th>
      <th>유형</th>
      <th>이름</th>
      <th>식별번호</th>
      <th>예약일</th>
      <th>예약기간</th>
      <th>반납</th>
      <th>상태/취소</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${facility}" var="f">
      <tr>
        <td>${f.facId}</td>
        <td>${f.commName}</td>
        <td>${f.facName}</td>
        <td>${f.facUid}</td>
        <td>${f.createdAt}</td>
        <td>${f.startAt} ~ ${f.endAt}</td>
        <td>
          <c:if test="${f.rentYn=='N' and f.cancelStatus=='N'}">
          <button type="button"
                     class="btn btn-sm btn-outline-success d-flex align-items-center"
                     onclick="returnFacility('${f.facId}')">
          <i class="bi bi-arrow-counterclockwise me-1"></i> 반납
        </button>
          </c:if>
        </td>
        <td>
          <c:choose>
            <c:when test="${f.cancelStatus == 'Y' and  f.rentYn == 'Y'}">
              <span class="text-danger fw-bold">[취소됨]</span>
            </c:when>
            <c:when test="${f.rentYn == 'Y'}">
              <span class="text-success fw-bold">[반납완료]</span>
            </c:when>
            <c:otherwise>
              <button type="button"
                      class="btn btn-outline-danger btn-sm d-flex align-items-center"
                      onclick="delReserve('${f.facId}')">
                <i class="bi bi-x-circle me-1"></i> 취소
              </button>

            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <!-- 페이징 -->
  <nav class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item">
        <a class="page-link" href="?page=${pageDto.page - 1}&facType=${param.facType}&yearMonth=${param.yearMonth}&keyword=${param.keyword}&includeCancel=${param.includeCancel}">이전</a>
      </li>
      <c:forEach begin="${pageDto.startPage}" end="${pageDto.endPage}" var="p">
        <li class="page-item <c:if test='${p == pageDto.page}'>active</c:if>'">
          <a class="page-link" href="?page=${p}&facType=${param.facType}&yearMonth=${param.yearMonth}&keyword=${param.keyword}&includeCancel=${param.includeCancel}">${p}</a>
        </li>
      </c:forEach>
      <li class="page-item">
        <a class="page-link" href="?page=${pageDto.page + 1}&facType=${param.facType}&yearMonth=${param.yearMonth}&keyword=${param.keyword}&includeCancel=${param.includeCancel}">다음</a>
      </li>
    </ul>
  </nav>
</div>

<script>
  function delReserve(facId) {
    if (confirm("예약을 취소하시겠습니까?")) {
      // Ajax 또는 location.href로 취소 처리
      location.href = "cancelReservation?facId=" + facId;
    }
  }

  function returnFacility(facId){
    if(confirm("반납처리를 하겠습니까?")){
      location.href = "returnFacility?facId="+facId;
    }
  }
</script>

</body>
</html>
