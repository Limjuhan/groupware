<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>연차 사용률 대시보드</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1200px; margin-top: 40px; }
    .filter-box { background-color: #fff; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
    .table thead th { background-color: #f1f3f5; }
  </style>
</head>
<body>
<div class="container">
  <h3 class="mb-4 fw-bold">📊 연차 사용률 대시보드</h3>



  <!-- 필터 영역 -->
  <div class="filter-box shadow-sm">
    <form class="row g-3">
      <div class="col-md-3">
        <label class="form-label">연도</label>
        <select id="yearFilter" class="form-select" onchange="updateDashboard()">
          <option selected>2025</option>
          <option>2024</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label">부서</label>
        <select id="deptFilter" class="form-select" onchange="updateDashboard()">
          <option selected>전체</option>
          <option>개발팀</option>
          <option>영업팀</option>
          <option>고객지원팀</option>
          <option>경영지원팀</option>
        </select>
      </div>
    </form>
  </div>

<!-- 차트 -->
  <div class="card p-4 mb-4">
    <canvas id="leaveChart" height="100"></canvas>
  </div>

  <!-- 테이블 -->
  <div class="card p-4">
    <div class="d-flex justify-content-between mb-3">
      <h5 class="fw-bold">부서별 직원 연차 현황</h5>
      <button class="btn btn-sm btn-outline-success">엑셀 다운로드</button>
    </div>
    <table class="table table-bordered text-center" id="leaveTable">
      <thead>
        <tr>
          <th>부서</th>
          <th>이름</th>
          <th>직급</th>
          <th>총 연차</th>
          <th>사용 연차</th>
          <th>잔여 연차</th>
          <th>사용률(%)</th>
        </tr>
      </thead>
      <tbody id="leaveTableBody">
        <!-- JS로 동적 렌더링 -->
      </tbody>
    </table>
  </div>
</div>

<script>
  // 연도별 부서별 데이터
  const rawData = {
    "2025": {
      "개발팀": [
        { name: "김동곤", grade: "대리", total: 15, used: 5 },
        { name: "정호준", grade: "팀장", total: 20, used: 10 }
      ],
      "영업팀": [
        { name: "최윤아", grade: "주임", total: 15, used: 9 }
      ],
      "고객지원팀": [
        { name: "박지성", grade: "사원", total: 15, used: 12 }
      ],
      "경영지원팀": [
        { name: "이정은", grade: "과장", total: 15, used: 2 }
      ]
    },
    "2024": {
      "개발팀": [
        { name: "김동곤", grade: "대리", total: 15, used: 7 }
      ],
      "영업팀": [
        { name: "최윤아", grade: "주임", total: 15, used: 11 }
      ],
      "고객지원팀": [
        { name: "박지성", grade: "사원", total: 15, used: 8 }
      ],
      "경영지원팀": [
        { name: "이정은", grade: "과장", total: 15, used: 4 }
      ]
    }
  };

  let chartInstance = null;

  function updateDashboard() {
    const year = document.getElementById("yearFilter").value;
    const dept = document.getElementById("deptFilter").value;

    const yearData = rawData[year];
    const filteredDepts = dept === "전체" ? Object.keys(yearData) : [dept];

    // 테이블 렌더링
    const tbody = document.getElementById("leaveTableBody");
    tbody.innerHTML = "";
    filteredDepts.forEach(function(team) {
      yearData[team].forEach(function(emp) {
        const remain = emp.total - emp.used;
        const percent = Math.round((emp.used / emp.total) * 100);
        const row =
          "<tr>" +
            "<td>" + team + "</td>" +
            "<td>" + emp.name + "</td>" +
            "<td>" + emp.grade + "</td>" +
            "<td>" + emp.total + "</td>" +
            "<td>" + emp.used + "</td>" +
            "<td>" + remain + "</td>" +
            "<td>" + percent + "%</td>" +
          "</tr>";
        tbody.insertAdjacentHTML("beforeend", row);
      });
    });

    // 차트 데이터 준비
    const chartLabels = filteredDepts;
    const usedData = [];
    const remainData = [];

    chartLabels.forEach(function(team) {
      const teamData = yearData[team];
      let usedSum = 0, remainSum = 0;
      teamData.forEach(function(emp) {
        usedSum += emp.used;
        remainSum += (emp.total - emp.used);
      });
      usedData.push(usedSum);
      remainData.push(remainSum);
    });

    // 차트 렌더링
    if (chartInstance) chartInstance.destroy();
    const ctx = document.getElementById("leaveChart").getContext("2d");
    chartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: "사용 연차",
            data: usedData,
            backgroundColor: "rgba(54, 162, 235, 0.7)",
            stack: "연차"
          },
          {
            label: "잔여 연차",
            data: remainData,
            backgroundColor: "rgba(255, 99, 132, 0.7)",
            stack: "연차"
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          tooltip: { mode: "index", intersect: false },
          legend: { position: "top" }
        },
        scales: {
          x: { stacked: true },
          y: { stacked: true, beginAtZero: true }
        }
      }
    });
  }

  // 초기 렌더링
  window.onload = updateDashboard;
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
