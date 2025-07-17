<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원 등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .form-section {
      max-width: 800px;
      margin: 50px auto;
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .photo-preview {
      width: 100px;
      height: 100px;
      background-color: #e9ecef;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 5px;
      font-size: 12px;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>
  <div class="form-section">
    <h3 class="mb-4 fw-bold">회원등록</h3>
    <form>
      <div class="row mb-3">
        <div class="col-md-3 text-center">
          <div class="photo-preview mb-2">사진<br>없음</div>
          <input type="file" class="form-control form-control-sm" />
        </div>
        <div class="col-md-9">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">이름 *</label>
              <input type="text" class="form-control" value="동곤">
            </div>
            <div class="col-md-6">
              <label class="form-label">이메일 *</label>
              <input type="email" class="form-control" value="donggon@ldbsoft.co.kr">
            </div>
            <div class="col-md-6">
              <label class="form-label">전화번호 *</label>
              <input type="text" class="form-control" value="010-1234-5678">
            </div>
            <div class="col-md-6">
              <label class="form-label">부서 *</label>
              <input type="text" class="form-control" value="개발팀">
            </div>
            <div class="col-md-6">
              <label class="form-label">직급 *</label>
              <input type="text" class="form-control" value="대리">
            </div>
            <div class="col-md-6">
              <label class="form-label">권한 *</label>
              <input type="text" class="form-control" value="LEVEL1">
            </div>
            <div class="col-md-6">
              <label class="form-label">재직상태 *</label>
              <input type="text" class="form-control" value="재직">
            </div>
            <div class="col-md-6">
              <label class="form-label">입사일 *</label>
              <input type="date" class="form-control" value="2021-03-01">
            </div>
            <div class="col-md-6">
              <label class="form-label">성별</label>
              <select class="form-select">
                <option selected>남</option>
                <option>여</option>
              </select>
            </div>
            <div class="col-md-6">
              <label class="form-label">생년월일</label>
              <input type="date" class="form-control" value="1990-01-01">
            </div>
            <div class="col-md-12">
              <label class="form-label">주소</label>
              <input type="text" class="form-control" value="서울특별시 강남구 테헤란로">
            </div>

          </div>
        </div>
      </div>
      <div class="text-end">
        <button type="submit" class="btn btn-primary">저장</button>
        <button type="reset" class="btn btn-secondary">취소</button>
      </div>
    </form>
  </div>
</body>
</html>
