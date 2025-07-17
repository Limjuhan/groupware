<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>개인정보 관리 - LDBSOFT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f4f6f9;
    }
    .container {
      max-width: 900px;
      margin-top: 40px;
    }
    .img-thumbnail {
      max-width: 150px;
    }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4">개인정보 관리</h2>
  <form method="post" action="updateProfile.jsp" enctype="multipart/form-data">
    <div class="row mb-4">
      <div class="col-md-3 text-center">
        <img src="profile_default.png" alt="사원 사진" class="img-thumbnail mb-2">
        <!-- ✅ 사진만 수정 가능 -->
        <input type="file" class="form-control" name="photo">
      </div>
      <div class="col-md-9">
        <div class="row g-3">
          <!-- ❌ readonly 필드 (회색 처리) -->
          <div class="col-md-6">
            <label class="form-label">이름 *</label>
            <input type="text" class="form-control bg-light" name="name" value="동곤" readonly>
          </div>
          <div class="col-md-6">
            <label class="form-label">이메일 *</label>
            <input type="email" class="form-control bg-light" name="email" value="donggon@ldbsoft.co.kr" readonly>
          </div>

          <!-- ✅ 전화번호만 수정 가능 -->
          <div class="col-md-6">
            <label class="form-label">전화번호 *</label>
            <input type="text" class="form-control" name="phone" value="010-1234-5678">
          </div>

          <!-- ❌ 나머지 모두 회색 처리 -->
          <div class="col-md-6">
            <label class="form-label">부서 *</label>
            <input type="text" class="form-control bg-light" name="department" value="개발팀" readonly>
          </div>
          <div class="col-md-6">
            <label class="form-label">직급 *</label>
            <input type="text" class="form-control bg-light" name="position" value="대리" readonly>
          </div>
          <div class="col-md-6">
            <label class="form-label">재직상태 *</label>
            <input type="text" class="form-control bg-light" name="status" value="재직" readonly>
          </div>
          <div class="col-md-6">
            <label class="form-label">입사일 *</label>
            <input type="date" class="form-control bg-light" name="hireDate" value="2021-03-01" readonly>
          </div>

          <div class="col-md-6">
            <label class="form-label">성별</label>
            <select class="form-select bg-light" name="gender" disabled>
              <option selected>남</option>
              <option>여</option>
            </select>
          </div>
          <div class="col-md-6">
            <label class="form-label">생년월일</label>
            <input type="date" class="form-control bg-light" name="birthDate" value="1990-01-01" readonly>
          </div>

          <!-- ✅ 주소는 수정 가능 -->
          <div class="col-md-12">
            <label class="form-label">주소</label>
            <input type="text" class="form-control" name="address" value="서울특별시 강남구 테헤란로">
          </div>
        </div>
      </div>
    </div>

     <!-- 3. 연차 정보 -->
        <h5 class="section-title">연차 정보</h5>
        <div class="row mb-3">
            <div class="col-md-4">
                <div class="border p-3 bg-light">
                    <strong>총 연차:</strong> 15일<br>
                    <strong>사용 연차:</strong> 6일<br>
                    <strong>잔여 연차:</strong> 9일
                </div>
            </div>
        </div>

        <h6 class="mt-3">연차 사용 내역</h6>
        <table class="table table-bordered">
            <thead class="table-light">
                <tr>
                    <th>기간</th>
                    <th>결재자</th>
                    <th>휴가 종류</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>2025-01-15 ~ 2025-01-16</td>
                    <td>김이사</td>
                    <td>연차</td>
                </tr>
                <tr>
                    <td>2025-05-03</td>
                    <td>김이사</td>
                    <td>오전 반차</td>
                </tr>
            </tbody>
        </table>


    <div class="text-end">
      <button type="submit" class="btn btn-primary">저장</button>
      <a href="/" class="btn btn-secondary">취소</a>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
