<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>받은 전자결재 - LDBSOFT</title>
    <style>
        body {
            color: white;
        }

        .container {
            max-width: 1200px;
            margin-top: 40px;
        }

        /* 테이블 내부 glass 적용 */
        .table.bg-glass td, .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        /* select box 화살표 */
        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: "▼";
            position: absolute;
            top: 60%;
            right: 1.0rem;
            transform: translateY(-60%);
            pointer-events: none;
            color: white;
            font-size: 1.2rem;
        }

        .form-select.bg-glass option {
            background-color: #ffffff;
            color: #000000;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
        }

        a.link-white:hover {
            color: #ffffff;
        }
    </style>
</head>
<body>
<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="text-shadow">받은 전자결재</h2>
    </div>

    <!-- 검색 필터 -->
    <form class="row g-2 mb-4" id="searchForm" onsubmit="event.preventDefault(); filterTable();">
        <div class="col-md-3 select-wrapper">
            <select class="form-select bg-glass" id="searchType">
                <option value="title">제목</option>
                <option value="writer">기안자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" class="form-control bg-glass" placeholder="검색어 입력" id="searchKeyword">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-primary w-100 bg-glass">검색</button>
        </div>
    </form>

    <table class="table table-hover table-bordered text-center align-middle bg-glass" id="approvalTable">
        <thead class="table-light">
        <tr>
            <th>문서번호</th>
            <th>제목</th>
            <th>문서종료일</th>
            <th>기안자</th>
            <th>1차 결재자</th>
            <th>2차 결재자</th>
            <th>상태</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>A00001</td>
            <td><a href="draftManagement?id=A00001" class="link-white">휴가신청서(5/1~5/3)</a></td>
            <td>2025-05-01</td>
            <td>동곤</td>
            <td>김대리</td>
            <td>이과장</td>
            <td><span class="badge bg-warning text-dark">1차결재 대기</span></td>
        </tr>
        <tr>
            <td>A00002</td>
            <td><a href="receivedDraftDetail?id=A00002" class="link-white">지출결의서(회의비)</a></td>
            <td>2025-05-02</td>
            <td>동곤</td>
            <td>김대리</td>
            <td>이과장</td>
            <td><span class="badge bg-success">2차결재 승인</span></td>
        </tr>
        <tr>
            <td>A00003</td>
            <td><a href="receivedDraftDetail?id=A00003" class="link-white">출장신청서(부산)</a></td>
            <td>2025-05-03</td>
            <td>동곤</td>
            <td>김대리</td>
            <td>이과장</td>
            <td><span class="badge bg-warning text-dark">1차결재 대기</span></td>
        </tr>
        <tr>
            <td>A00004</td>
            <td><a href="draftManagement?id=A00004" class="link-white">연차신청서(5/10)</a></td>
            <td>2025-05-04</td>
            <td>동곤</td>
            <td>김대리</td>
            <td>이과장</td>
            <td><span class="badge bg-warning text-dark">1차결재 대기</span></td>
        </tr>
        <tr>
            <td>A00005</td>
            <td><a href="draftManagement?id=A00005" class="link-white">경조사비 신청</a></td>
            <td>2025-05-05</td>
            <td>동곤</td>
            <td>김대리</td>
            <td>이과장</td>
            <td><span class="badge bg-success">2차결재 승인</span></td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    function filterTable() {
        const type = document.getElementById("searchType").value;
        const keyword = document.getElementById("searchKeyword").value.toLowerCase();
        const rows = document.querySelectorAll("#approvalTable tbody tr");

        const columnIndex = (type === "title") ? 1 : 3;

        rows.forEach(row => {
            const text = row.cells[columnIndex].innerText.toLowerCase();
            row.style.display = text.includes(keyword) ? "" : "none";
        });
    }
</script>

</body>
</html>
