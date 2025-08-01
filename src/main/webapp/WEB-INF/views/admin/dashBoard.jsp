<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>연차 사용률 대시보드</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <style>
    body {
      background: linear-gradient(135deg, #f4f6f9, #e9ecf3);
      font-family: 'Pretendard', sans-serif;
    }
    .container { max-width: 1500px; margin-top: 40px; }
    .filter-box {
      backdrop-filter: blur(10px);
      background: rgba(255, 255, 255, 0.7);
      padding: 20px; border-radius: 15px;
      margin-bottom: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .card {
      backdrop-filter: blur(8px);
      background: rgba(255, 255, 255, 0.8);
      border: none;
      border-radius: 15px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .table {
      border-collapse: separate;
      border-spacing: 0;
    }
    .table thead th {
      background-color: rgba(241, 243, 245, 0.8);
      border-bottom: 2px solid #dee2e6;
    }
    .table tbody tr:hover {
      background-color: rgba(0, 123, 255, 0.05);
    }
    .table td, .table th {
      border: 1px solid #dee2e6;
      vertical-align: middle;
    }
    .btn-glass {
      backdrop-filter: blur(6px);
      background: rgba(255, 255, 255, 0.5);
      border: 1px solid rgba(255,255,255,0.2);
      transition: 0.2s;
    }
    .btn-glass:hover {
      background: rgba(255,255,255,0.8);
    }
    /* 페이징 스타일 */
    .pagination {
      justify-content: center;
    }
    .pagination .page-item.active .page-link {
      background-color: #0d6efd;
      border-color: #0d6efd;
      color: white;
    }
    .pagination .page-link {
      color: #0d6efd;
    }
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
        <select id="yearFilter" class="form-select"></select>
      </div>
      <div class="col-md-3">
        <label class="form-label">부서</label>
        <select id="deptFilter" class="form-select">
          <option value="" selected>전체</option>
        </select>
      </div>
      <div class="col-md-3 d-flex align-items-end">
        <button type="button" class="btn btn-primary w-100" id="btnSearch">검색</button>
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
      <button class="btn btn-sm btn-outline-success" id="btnExcel">엑셀 다운로드</button>
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
        <th>수정</th>
      </tr>
      </thead>
      <tbody id="leaveTableBody">
      <!-- JS로 동적 렌더링 -->
      </tbody>
    </table>
    <!-- 페이징 -->
    <nav>
      <ul class="pagination" id="pagination"></ul>
    </nav>
  </div>
</div>

<script>
  var chartInstance = null;
  var currentPage = 1;

  // 연도 Select 동적 생성 (최근 3년)
  function setYearOptions() {
    var now = new Date().getFullYear();
    var $yearSelect = $("#yearFilter");
    $yearSelect.empty();
    for (var i = 0; i < 3; i++) {
      var year = now - i;
      $yearSelect.append('<option value="' + year + '">' + year + '</option>');
    }
  }

  function loadDashboard(page) {
    currentPage = page || 1;
    var year = $("#yearFilter").val();
    var dept = $("#deptFilter").val();

    $.ajax({
      url: "/admin/getAnnualLeaveUsage",
      method: "GET",
      data: { year: year, deptId: dept, page: currentPage },
      success: function(res) {
        console.log(res.message);
        if (!res || !res.success) {
          alert("데이터조회중 오류가 발생하였습니다.");
          return;
        }
        var data = res.data.list;
        renderTable(data);
        renderChart(data);
        if (res.data.pageInfo) renderPagination(res.data.pageInfo);
      },
      error: function(error) {
        alert("데이터를 불러오는 중 오류가 발생했습니다.");
      }
    });
  }

  function renderTable(data) {
    var $tbody = $("#leaveTableBody");
    $tbody.empty();

    $.each(data, function(i, emp) {
      var row = '<tr data-mem-id="' + emp.memId + '">'
              + '<td>' + emp.deptName + '</td>'
              + '<td>' + emp.memName + '</td>'
              + '<td>' + emp.rankName + '</td>'
              + '<td><input type="number" class="form-control form-control-sm totalDays" value="' + emp.totalDays + '"></td>'
              + '<td><input type="number" class="form-control form-control-sm useDays" value="' + emp.useDays + '"></td>'
              + '<td><input type="number" class="form-control form-control-sm remainDays" value="' + emp.remainDays + '"></td>'
              + '<td>' + emp.annualPercent + '</td>'
              + '<td><button class="btn btn-sm btn-success btnSaveRow">저장</button></td>'
              + '</tr>';
      $tbody.append(row);
    });
  }

  function renderChart(data) {
    var deptMap = {};
    $.each(data, function(i, emp) {
      if (!deptMap[emp.deptName]) deptMap[emp.deptName] = { used: 0, remain: 0 };
      deptMap[emp.deptName].used += emp.useDays;
      deptMap[emp.deptName].remain += emp.remainDays;
    });

    var labels = [], usedData = [], remainData = [];
    $.each(deptMap, function(dept, values) {
      labels.push(dept);
      usedData.push(values.used);
      remainData.push(values.remain);
    });

    if (chartInstance) chartInstance.destroy();
    var ctx = document.getElementById("leaveChart").getContext("2d");
    chartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: labels,
        datasets: [
          { label: "사용 연차", data: usedData, backgroundColor: "rgba(54, 162, 235, 0.7)", stack: "연차" },
          { label: "잔여 연차", data: remainData, backgroundColor: "rgba(255, 99, 132, 0.7)", stack: "연차" }
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

  // 페이징 렌더링
  function renderPagination(pageInfo) {
    var $pagination = $("#pagination");
    $pagination.empty();

    if (pageInfo.totalPages <= 1) return;

    if (pageInfo.page > 1) {
      $pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (pageInfo.currentPage - 1) + '">이전</a></li>');
    }
    for (var i = pageInfo.startPage; i <= pageInfo.endPage; i++) {
      var active = (i === pageInfo.currentPage) ? "active" : "";
      $pagination.append('<li class="page-item ' + active + '"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
    }
    if (pageInfo.totalPages > page) {
      $pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (pageInfo.currentPage + 1) + '">다음</a></li>');
    }
  }

  $("#btnSearch").on("click", function() { loadDashboard(1); });
  $("#pagination").on("click", "a", function(e) {
    e.preventDefault();
    var page = $(this).data("page");
    loadDashboard(page);
  });

  $("#btnExcel").on("click", function() {
    var year = $("#yearFilter").val();
    var dept = $("#deptFilter").val();
    window.location.href = "/admin/annualLeaveExcel?year=" + year + "&deptId=" + dept;
  });

  function getDeptList() {
    $.ajax({
      url: "/admin/getDeptList",
      method: "GET",
      success: function(res) {
        if (!res || !res.success) {
          alert(res.message || "부서 목록을 불러오지 못했습니다.");
          return;
        }
        var deptList = res.data;
        var $deptFilter = $("#deptFilter");
        $deptFilter.empty().append('<option value="" selected>전체</option>');
        $.each(deptList, function(i, deptDto) {
          $deptFilter.append('<option value="' + deptDto.deptId + '">' + deptDto.deptName + '</option>');
        });
      },
      error: function() {
        alert("부서목록을 불러오는 중 오류가 발생했습니다.");
      }
    });
  }

  $(document).ready(function() {
    setYearOptions();
    getDeptList();
    loadDashboard();
  });
</script>
</body>
</html>
