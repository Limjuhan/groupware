<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원 설정</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 600px; margin-top: 60px; }
  </style>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">👤 회원 설정</h4>

  <form action="memberLevelProc.jsp" method="post">
    <!-- 사원번호 -->
    <div class="mb-3">
      <label for="empNo" class="form-label">사원번호</label>
      <input type="text" class="form-control" id="empNo" name="empNo" value="20250001" readonly>
    </div>

    <!-- 이름 -->
    <div class="mb-3">
      <label class="form-label">이름</label>
      <input type="text" class="form-control" value="김동곤" readonly>
    </div>

    <!-- 부서 -->
    <div class="mb-3">
      <label for="dept" class="form-label">부서</label>
      <select id="dept" name="dept" class="form-select" required>
        <option value="">-- 선택 --</option>
        <option value="개발팀">개발팀</option>
        <option value="디자인팀">디자인팀</option>
        <option value="영업팀">영업팀</option>
        <option value="총무팀">총무팀</option>
      </select>
    </div>

    <!-- 직급 -->
    <div class="mb-3">
      <label for="position" class="form-label">직급</label>
      <select id="position" name="position" class="form-select" required>
        <option value="">-- 선택 --</option>
        <option value="사원">사원</option>
        <option value="주임">주임</option>
        <option value="대리">대리</option>
        <option value="과장">과장</option>
        <option value="팀장">팀장</option>
      </select>
    </div>

    <!-- 권한 변경 선택 -->
    <div class="mb-4">
      <label for="newLevel" class="form-label">권한 레벨 설정</label>
      <select id="newLevel" name="newLevel" class="form-select" required>
        <option value="">-- 선택 --</option>
        <option value="1">1 (일반 사용자)</option>
        <option value="2">2 (부서 관리자)</option>
        <option value="3">3 (최고 관리자)</option>
      </select>
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <a href="adminMemberManage.jsp" class="btn btn-outline-secondary">← 목록</a>
      <button type="submit" class="btn btn-primary">저장</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
