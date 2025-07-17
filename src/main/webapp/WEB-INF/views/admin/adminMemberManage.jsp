<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 사원 관리</title>
  <style>
    body { background-color: #f8f9fa; }
    .container { max-width: 1000px; margin-top: 60px; }
    .table td, .table th { vertical-align: middle; text-align: center; }
    .name-link {
      color: #0d6efd;
      text-decoration: underline;
      cursor: pointer;
    }
  </style>
  <script>
    function openEmployeeDetail(empNo) {
      const url = "employeeDetail?empNo=" + empNo;
      window.open(url, "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
    }

    function filterRows() {
      const dept = document.getElementById("deptFilter").value;
      const rank = document.getElementById("rankFilter").value;
      const name = document.getElementById("nameFilter").value.trim().toLowerCase();
      const rows = document.querySelectorAll("#memberTableBody tr");

      rows.forEach(row => {
        const rowDept = row.getAttribute("data-dept");
        const rowRank = row.getAttribute("data-rank");
        const rowName = row.querySelector("td:nth-child(2)").textContent.toLowerCase();

        const matchDept = !dept || rowDept === dept;
        const matchRank = !rank || rowRank === rank;
        const matchName = !name || rowName.includes(name);

        if (matchDept && matchRank && matchName) {
          row.style.display = "";
        } else {
          row.style.display = "none";
        }
      });
    }
  </script>
</head>
<body>
<div class="container bg-white shadow-sm rounded p-5">
  <h4 class="mb-4 fw-bold">👤 사원 관리</h4>


  <!-- 필터 -->
  <form class="row g-3 mb-4" onsubmit="event.preventDefault(); filterRows();">
    <div class="col-md-3">
      <label class="form-label">부서</label>
      <select id="deptFilter" class="form-select">
        <option value="">전체</option>
        <option>개발팀</option>
        <option>영업팀</option>
        <option>총무팀</option>
        <option>디자인팀</option>
      </select>
    </div>
    <div class="col-md-3">
      <label class="form-label">직급</label>
      <select id="rankFilter" class="form-select">
        <option value="">전체</option>
        <option>사원</option>
        <option>주임</option>
        <option>대리</option>
        <option>과장</option>
        <option>팀장</option>
      </select>
    </div>
    <div class="col-md-4">
      <label class="form-label">이름</label>
      <input type="text" id="nameFilter" class="form-control" placeholder="이름 입력 (예: 동곤)">
    </div>
    <div class="col-md-2 d-flex align-items-end">
      <button type="submit" class="btn btn-outline-primary w-100">검색</button>
    </div>
  </form>
  <a href="registerUser" class="btn btn-success w-100">+ 등록</a>

  <!-- 회원 테이블 -->
  <table class="table table-bordered">
    <thead class="table-light">
      <tr>
        <th>사원번호</th>
        <th>이름</th>
        <th>부서</th>
        <th>직급</th>
        <th>레벨</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="memberTableBody">
      <tr data-dept="개발팀" data-rank="대리">
        <td>20250001</td>
        <td><span class="name-link" onclick="openEmployeeDetail('20250001')">김동곤</span></td>
        <td>개발팀</td>
        <td>대리</td>
        <td>1</td>
        <td><a href="memberInfoUpdate?empNo=20250001" class="btn btn-sm btn-outline-primary">설정</a></td>
      </tr>
      <tr data-dept="영업팀" data-rank="과장">
        <td>20250002</td>
        <td><span class="name-link" onclick="openEmployeeDetail('20250002')">이정은</span></td>
        <td>영업팀</td>
        <td>과장</td>
        <td>2</td>
        <td><a href="memberInfoUpdate?empNo=20250002" class="btn btn-sm btn-outline-primary">설정</a></td>
      </tr>
      <tr data-dept="총무팀" data-rank="사원">
        <td>20250003</td>
        <td><span class="name-link" onclick="openEmployeeDetail('20250003')">박지성</span></td>
        <td>총무팀</td>
        <td>사원</td>
        <td>1</td>
        <td><a href="memberInfoUpdate?empNo=20250003" class="btn btn-sm btn-outline-primary">설정</a></td>
      </tr>
      <tr data-dept="디자인팀" data-rank="주임">
        <td>20250004</td>
        <td><span class="name-link" onclick="openEmployeeDetail('20250004')">최윤아</span></td>
        <td>디자인팀</td>
        <td>주임</td>
        <td>1</td>
        <td><a href="memberInfoUpdate?empNo=20250004" class="btn btn-sm btn-outline-primary">설정</a></td>
      </tr>
      <tr data-dept="개발팀" data-rank="팀장">
        <td>20250005</td>
        <td><span class="name-link" onclick="openEmployeeDetail('20250005')">정호준</span></td>
        <td>개발팀</td>
        <td>팀장</td>
        <td>3</td>
        <td><a href="memberInfoUpdate?empNo=20250005" class="btn btn-sm btn-outline-primary">설정</a></td>
      </tr>
    </tbody>
  </table>
</div>

</body>
</html>
