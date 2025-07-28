<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>부서별 메뉴 권한 설정</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

  <style>
    body {
      background-color: #1e1e1e;
      color: white;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    }

    .container.bg-glass {
      background: rgba(255, 255, 255, 0.05) !important;
      backdrop-filter: blur(1px);
      -webkit-backdrop-filter: blur(1px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 0.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .form-label {
      font-weight: bold;
    }

    .select-wrapper {
      position: relative;
    }

    .form-select.bg-glass.custom-select-arrow {
      appearance: none;
      background: rgba(255, 255, 255, 0.05) !important;
      color: white;
      border: 1px solid rgba(255, 255, 255, 0.3);
      backdrop-filter: blur(1px);
      padding-right: 2.5rem;
      border-radius: 0.5rem;
    }

    .select-wrapper::after {
      content: "▼";
      position: absolute;
      top: 65%;
      right: 1.0rem;
      transform: translateY(-40%);
      pointer-events: none;
      color: white;
      font-size: 1.2rem;
    }

    .form-select.bg-glass option {
      background-color: #ffffff;
      color: #000000;
    }

    .table.bg-glass th,
    .table.bg-glass td {
      background: rgba(255, 255, 255, 0.05) !important;
      border: 1px solid rgba(255, 255, 255, 0.05);
      color: white;
      vertical-align: middle;
      text-align: center;
    }

    .btn.bg-glass {
      background: rgba(255, 255, 255, 0.1) !important;
      color: white;
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 0.5rem;
    }

    .btn.bg-glass:hover {
      background: rgba(255, 255, 255, 0.2) !important;
    }

    h3 {
      text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
    }
  </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded mt-5">
  <h3 class="mb-4">🔐 부서별 메뉴 권한 설정</h3>

  <div class="row mb-4">
    <div class="col-md-12 select-wrapper">
      <label for="deptSelect" class="form-label">부서 선택</label>
      <select id="deptSelect" class="form-select bg-glass custom-select-arrow">
        <option selected disabled>부서를 선택하세요</option>
        <c:forEach var="dept" items="${deptList}">
          <option value="${dept.deptId}">${dept.deptName}</option>
        </c:forEach>
      </select>
    </div>
  </div>

  <form id="authForm">
    <table class="table table-bordered bg-glass">
      <thead>
      <tr>
        <th>메뉴 코드</th>
        <th>메뉴 명</th>
        <th>권한 부여</th>
      </tr>
      </thead>
      <tbody id="permissionTable">
      <!-- JS에서 메뉴 동적 로딩 -->
      </tbody>
    </table>

    <div class="text-end">
      <button type="button" class="btn btn-primary bg-glass" onclick="savePermissions()">💾 저장</button>
    </div>
  </form>
</div>

<script>
  var allMenus = [];

  $(document).ready(function () {
    // 전체 메뉴 목록 불러오기
    $.get("/admin/menuList", function (res) {
      allMenus = res;
    });

    // 부서 선택 시 권한 불러오기
    $('#deptSelect').on('change', function () {
      var deptId = $(this).val();

      $.get("/admin/menuAuthority", { deptId: deptId }, function (selectedCodes) {
        renderMenuTable(selectedCodes);
      });
    });
  });

  function renderMenuTable(selectedCodes) {
    var tbody = document.getElementById("permissionTable");
    tbody.innerHTML = "";

    allMenus.forEach(function (menu) {
      var isChecked = selectedCodes.includes(menu.menuCode) ? "checked" : "";
      var row = ""
              + "<tr>"
              +     "<td>" + menu.menuCode + "</td>"
              +     "<td>" + menu.menuName + "</td>"
              +     "<td><input type='checkbox' name='menuCode' value='" + menu.menuCode + "' " + isChecked + "></td>"
              + "</tr>";
      tbody.insertAdjacentHTML("beforeend", row);
    });
  }

  function savePermissions() {
    var deptId = document.getElementById('deptSelect').value;
    if (!deptId) {
      alert("부서를 먼저 선택하세요.");
      return;
    }

    var selected = [];
    var checkboxes = document.querySelectorAll('input[name="menuCode"]:checked');
    checkboxes.forEach(function (input) {
      selected.push(input.value);
    });

    fetch("/admin/menuAuthority?deptId=" + deptId, {
      method: 'POST',
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(selected)
    }).then(function (res) {
      return res.json();
    }).then(function (res) {
      alert(res.message);
    });
  }
</script>

</body>
</html>
