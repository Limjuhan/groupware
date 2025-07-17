<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공통코드 사용여부 관리</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1100px; margin-top: 40px; }
    .table th, .table td { vertical-align: middle; text-align: center; }
    .group-title { font-size: 1.25rem; font-weight: bold; margin-top: 40px; margin-bottom: 10px; }
  </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4 fw-bold">⚙️ 공통코드 사용여부 관리</h2>

  <!-- 코드 그룹별 반복 시작 -->

  <%-- 1. attach_type --%>
  <div class="group-title">📎 첨부유형 (attach_type)</div>
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>코드</th>
        <th>설명</th>
        <th>사용여부</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>A</td><td>질문게시판</td><td><input type="radio" name="attach_A" checked> Y <input type="radio" name="attach_A"> N</td></tr>
      <tr><td>D</td><td>전자결재</td><td><input type="radio" name="attach_D" checked> Y <input type="radio" name="attach_D"> N</td></tr>
      <tr><td>N</td><td>공지사항</td><td><input type="radio" name="attach_N"> Y <input type="radio" name="attach_N" checked> N</td></tr>
    </tbody>
  </table>

  <%-- 2. approval_type --%>
  <div class="group-title">📝 결재양식 유형 (approval_type)</div>
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>코드</th>
        <th>설명</th>
        <th>사용여부</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>app_01</td><td>휴가 신청서</td><td><input type="radio" name="app_01" checked> Y <input type="radio" name="app_01"> N</td></tr>
      <tr><td>app_02</td><td>프로젝트 제안서</td><td><input type="radio" name="app_02" checked> Y <input type="radio" name="app_02"> N</td></tr>
      <tr><td>app_03</td><td>지출결의서</td><td><input type="radio" name="app_03" checked> Y <input type="radio" name="app_03"> N</td></tr>
    </tbody>
  </table>

  <%-- 3. approval_status --%>
  <div class="group-title">📂 결재 상태 (approval_status)</div>
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>코드</th>
        <th>설명</th>
        <th>사용여부</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>0</td><td>임시저장</td><td><input type="radio" name="status_0" checked> Y <input type="radio" name="status_0"> N</td></tr>
      <tr><td>1</td><td>1차결재 대기</td><td><input type="radio" name="status_1" checked> Y <input type="radio" name="status_1"> N</td></tr>
      <tr><td>2</td><td>1차결재 승인</td><td><input type="radio" name="status_2" checked> Y <input type="radio" name="status_2"> N</td></tr>
      <tr><td>3</td><td>1차결재 반려</td><td><input type="radio" name="status_3"> Y <input type="radio" name="status_3" checked> N</td></tr>
      <tr><td>4</td><td>2차결재 대기</td><td><input type="radio" name="status_4" checked> Y <input type="radio" name="status_4"> N</td></tr>
      <tr><td>5</td><td>2차결재 승인</td><td><input type="radio" name="status_5" checked> Y <input type="radio" name="status_5"> N</td></tr>
      <tr><td>6</td><td>2차결재 반려</td><td><input type="radio" name="status_6" checked> Y <input type="radio" name="status_6"> N</td></tr>
    </tbody>
  </table>

  <%-- 4. leave_type --%>
  <div class="group-title">🌴 연차 유형 (leave_type)</div>
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>코드</th>
        <th>설명</th>
        <th>사용여부</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>ANNUAL</td><td>연차</td><td><input type="radio" name="leave_ANNUAL" checked> Y <input type="radio" name="leave_ANNUAL"> N</td></tr>
      <tr><td>HALF</td><td>반차</td><td><input type="radio" name="leave_HALF" checked> Y <input type="radio" name="leave_HALF"> N</td></tr>
      <tr><td>EVENT</td><td>경조사</td><td><input type="radio" name="leave_EVENT" checked> Y <input type="radio" name="leave_EVENT"> N</td></tr>
    </tbody>
  </table>

  <%-- 5. fac_type --%>
  <div class="group-title">🏢 공용설비 유형 (fac_type)</div>
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>코드</th>
        <th>설명</th>
        <th>사용여부</th>
      </tr>
    </thead>
    <tbody>
      <tr><td>R_01</td><td>차량</td><td><input type="radio" name="fac_R01" checked> Y <input type="radio" name="fac_R01"> N</td></tr>
      <tr><td>R_02</td><td>회의실</td><td><input type="radio" name="fac_R02" checked> Y <input type="radio" name="fac_R02"> N</td></tr>
      <tr><td>R_03</td><td>비품</td><td><input type="radio" name="fac_R03" checked> Y <input type="radio" name="fac_R03"> N</td></tr>
    </tbody>
  </table>

  <!-- 저장 버튼 -->
  <div class="text-end mt-4">
    <button class="btn btn-success">✅ 변경사항 저장</button>
  </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
