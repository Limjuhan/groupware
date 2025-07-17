<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>부서별 권한 설정</title>

  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 900px; margin-top: 40px; }
    .table th, .table td { vertical-align: middle; text-align: center; }
  </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded">
  <h3 class="fw-bold mb-4">🔐 부서별 권한 설정</h3>

  <!-- 부서 선택 -->
  <div class="mb-4">
    <label for="deptSelect" class="form-label fw-semibold">부서를 선택하세요</label>
    <select id="deptSelect" class="form-select" onchange="loadPermissions()">
      <option selected disabled>부서를 선택하세요</option>
      <option value="개발팀">개발팀 (기획/개발/디자인)</option>
      <option value="영업팀">영업팀</option>
      <option value="고객지원팀">고객지원팀 (CS)</option>
      <option value="경영지원팀">경영지원팀 (인사/총무/회계)</option>
    </select>
  </div>

  <!-- 권한 테이블 -->
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>권한 코드</th>
        <th>권한 명</th>
        <th>사용 여부</th>
      </tr>
    </thead>
    <tbody id="permissionTableBody">
      <!-- JavaScript로 동적 출력 -->
    </tbody>
  </table>

  <!-- 저장 버튼 -->
  <div class="text-end">
    <button class="btn btn-primary">저장</button>
  </div>
</div>

<script>
  // 권한 정의
  const permissionList = [
    { code: "A_001", name: "공지사항 관리" },
    { code: "A_002", name: "자주묻는질문 관리" },
    { code: "A_003", name: "일정 관리" },
    { code: "A_004", name: "공용설비 관리" },
    { code: "A_005", name: "회원 관리" },
    { code: "A_006", name: "연차사용률 조회" }
  ];

  // 부서별 권한 사용여부 초기값
  const departmentPermissions = {
    "개발팀": {
      A_001: "Y", A_002: "Y", A_003: "Y", A_004: "Y", A_005: "N", A_006: "Y"
    },
    "영업팀": {
      A_001: "Y", A_002: "N", A_003: "Y", A_004: "N", A_005: "N", A_006: "N"
    },
    "고객지원팀": {
      A_001: "Y", A_002: "Y", A_003: "N", A_004: "N", A_005: "N", A_006: "N"
    },
    "경영지원팀": {
      A_001: "Y", A_002: "Y", A_003: "Y", A_004: "Y", A_005: "Y", A_006: "Y"
    }
  };

  function loadPermissions() {
    const dept = document.getElementById("deptSelect").value;
    const tbody = document.getElementById("permissionTableBody");
    tbody.innerHTML = "";

    permissionList.forEach(function(permission) {
      const status = departmentPermissions[dept][permission.code] || "N";

      const row =
        "<tr>" +
          "<td>" + permission.code + "</td>" +
          "<td>" + permission.name + "</td>" +
          "<td>" +
            "<div class='form-check form-check-inline'>" +
              "<input class='form-check-input' type='radio' name='" + permission.code + "' value='Y' " + (status === "Y" ? "checked" : "") + "> Y" +
            "</div>" +
            "<div class='form-check form-check-inline'>" +
              "<input class='form-check-input' type='radio' name='" + permission.code + "' value='N' " + (status === "N" ? "checked" : "") + "> N" +
            "</div>" +
          "</td>" +
        "</tr>";

      tbody.insertAdjacentHTML("beforeend", row);
    });
  }
</script>

</body>
</html>
