<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사원 등록</title>
  <style>
    body {
      background-color: #f8f9fa;
    }
    .form-section {
      max-width: 800px;
      margin: 50px auto;
      background: rgba(255, 255, 255, 0.1);
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      backdrop-filter: blur(8px);
      -webkit-backdrop-filter: blur(8px);
      color: white;
    }
    .photo-preview {
      width: 100px;
      height: 100px;
      background-color: rgba(255, 255, 255, 0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 5px;
      font-size: 12px;
      margin-bottom: 10px;
      color: white;
    }
    .form-control, .form-select {
      background-color: rgba(255, 255, 255, 0.15) !important;
      color: white !important;
      border: 1px solid rgba(255, 255, 255, 0.3);
    }
    .form-select option {
      background-color: #343a40;
      color: white;
    }
    .form-label {
      font-weight: bold;
      color: white;
    }
    h3 {
      color: white;
      text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
    }
  </style>
</head>
<body>
<div class="form-section">
  <h3 class="mb-4 fw-bold">사원등록</h3>
  <form>
    <div class="row mb-3">
      <div class="col-md-3 text-center">
        <div class="photo-preview mb-2">사진<br>없음</div>
        <input type="file" class="form-control form-control-sm" name="photo" />
      </div>
      <div class="col-md-9">
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label">이름 *</label>
            <input type="text" class="form-control" name="memName" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">이메일 *</label>
            <input type="email" class="form-control" name="memEmail" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">전화번호 *</label>
            <input type="text" class="form-control" name="memPhone" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">부서 *</label>
            <select class="form-select" name="deptId" required>
              <option value="">부서 선택</option>
              <option value="D001">개발팀</option>
              <option value="D002">영업팀</option>
              <option value="D003">인사팀</option>
              <option value="D004">경영지원팀</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">직급 *</label>
            <select class="form-select" name="rankId" required>
              <option value="">직급 선택</option>
              <option value="R001">사원</option>
              <option value="R002">대리</option>
              <option value="R003">과장</option>
              <option value="R004">부장</option>
              <option value="R005">이사</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">재직상태 *</label>
            <select class="form-select" name="memStatus" required>
              <option value="">상태 선택</option>
              <option value="재직">재직</option>
              <option value="퇴직">퇴직</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">입사일 *</label>
            <input type="date" class="form-control" name="memHiredate" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">성별</label>
            <select class="form-select" name="memGender">
              <option value="">성별 선택</option>
              <option value="남">남</option>
              <option value="여">여</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">생년월일</label>
            <input type="date" class="form-control" name="birthDate">
          </div>
          <div class="col-md-12">
            <label class="form-label">주소</label>
            <input type="text" class="form-control" name="memAddress">
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