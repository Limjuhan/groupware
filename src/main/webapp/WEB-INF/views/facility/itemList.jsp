<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
  <h3 class="mb-4 fw-bold">비품 리스트</h3>

  <!-- 검색 및 필터 폼 -->
  <form class="row align-items-end g-3 search-form" method="get">
    <div class="col-md-6">
      <label for="keyword" class="form-label">비품명</label>
      <input type="text" id="keyword" class="form-control" name="keyword" placeholder="예: 노트북">
    </div>
    <div class="col-md-3">
      <label for="used" class="form-label">반납여부</label>
      <select name="used" id="used" class="form-select">
        <option value="">전체</option>
        <option value=">0">Y</option>
        <option value="0">N</option>
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
        <th style="width: 20%">공용설비ID</th>
        <th style="width: 40%">비품명</th>
        <th style="width: 20%">반납여부</th>
        <th style="width: 20%">예약</th>
      </tr>
    </thead>
    <tbody>
      <tr onclick="showDetail('P0001', '노트북', '업무용 고사양 노트북입니다.', 'Y')">
        <td>P0001</td>
        <td class="text-primary fw-semibold">노트북</td>
        <td>Y</td>
        <td><a href="itemRequestForm?code=P0001" class="btn btn-sm btn-primary">예약</a></td>
      </tr>
      <tr onclick="showDetail('P0002', '모니터', '27인치 Full HD 모니터입니다.', 'Y')">
        <td>P0002</td>
        <td class="text-primary fw-semibold">모니터</td>
        <td>Y</td>
        <td><a href="itemRequestForm?code=P0002" class="btn btn-sm btn-primary">예약</a></td>
      </tr>
      <tr onclick="showDetail('P0003', '마우스', '무선 블루투스 마우스입니다.', 'N')">
        <td>P0003</td>
        <td class="text-primary fw-semibold">마우스</td>
        <td>N</td>
        <td>-</td>
      </tr>
    </tbody>
  </table>
</div>

<!-- 품목 상세 모달 -->
<div class="modal fade" id="itemDetailModal" tabindex="-1" aria-labelledby="itemDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="itemDetailModalLabel">비품 상세 정보</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <ul class="list-group">
          <li class="list-group-item"><strong>공용설비ID:</strong> <span id="modalItemCode"></span></li>
          <li class="list-group-item"><strong>비품명:</strong> <span id="modalItemName"></span></li>
          <li class="list-group-item"><strong>상세정보:</strong> <span id="modalItemDesc"></span></li>
          <li class="list-group-item"><strong>반납여부:</strong> <span id="modalRetalYn"></span></li>
        </ul>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function showDetail(code, name, desc, retalYn) {
    document.getElementById("modalItemCode").innerText = code;
    document.getElementById("modalItemName").innerText = name;
    document.getElementById("modalItemDesc").innerText = desc;
    document.getElementById("modalRetalYn").innerText = retalYn;
    const modal = new bootstrap.Modal(document.getElementById("itemDetailModal"));
    modal.show();
  }
</script>
</body>
</html>
