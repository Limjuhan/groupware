<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비품 등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .container {
      max-width: 600px;
      margin-top: 60px;
    }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">비품 등록</h4>

  <form action="itemCodeWriteProc.jsp" method="post">
    <!-- 품목코드 -->
    <div class="mb-3">
      <label for="itemCode" class="form-label">공용설비ID</label>
      <input type="text" class="form-control" id="itemCode" name="itemCode" required placeholder="예: P0001">
    </div>

<!-- 식별번호 -->
    <div class="mb-3">
      <label for="itemName" class="form-label">식별번호</label>
      <input type="text" class="form-control" id="uid" name="uid" >
    </div>
    
    <!-- 품목명 -->
    <div class="mb-3">
      <label for="itemName" class="form-label">비품명</label>
      <input type="text" class="form-control" id="itemName" name="itemName" required placeholder="예: 노트북">
    </div>

 
    <!-- 상세정보 -->
    <div class="mb-3">
      <label for="itemDesc" class="form-label">상세정보</label>
      <textarea class="form-control" id="itemDesc" name="itemDesc" rows="4" placeholder="해당 품목에 대한 설명을 입력하세요."></textarea>
    </div>

   

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="itemListManage" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">등록</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
