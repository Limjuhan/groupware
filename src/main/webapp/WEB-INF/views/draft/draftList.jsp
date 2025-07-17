<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전자결재 - LDBSOFT</title>

    <style>
        body {
            color: white;
        }

        h2 {
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
        }

        #documentTable.bg-glass th,
        #documentTable.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
        }

        a.link-white:hover {
            color: #ffffff;
            text-decoration: underline;
        }

        /* select에 glass 효과 및 ▼ 커스텀 아이콘 추가 */
        .form-select.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            padding-right: 2rem;
            background-image: url("data:image/svg+xml,%3Csvg fill='white' height='18' viewBox='0 0 24 24' width='18' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1rem;
        }

        /* 밝은 option 배경 처리 */
        .form-select.bg-glass option {
            background-color: rgba(0, 0, 0, 0.8);
            color: white;
        }

        .form-label {
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>전자결재</h2>
        <a href="draftForm" class="btn btn-primary bg-glass">+ 새 결재문서 작성</a>
    </div>

    <!-- 검색 영역 -->
    <div class="row mb-3 align-items-end">
        <div class="col-md-3">
            <label for="searchType" class="form-label">검색 기준</label>
            <select id="searchType" class="form-select bg-glass">
                <option value="title">제목</option>
                <option value="writer">기안자</option>
            </select>
        </div>
        <div class="col-md-6">
            <label for="searchInput" class="form-label">검색어 입력</label>
            <input type="text" id="searchInput" class="form-control bg-glass" placeholder="검색어 입력">
        </div>
    </div>

    <!-- 결재문서 리스트 -->
    <h5 class="mb-3">내 결재문서 목록</h5>

    <table class="table table-hover table-bordered text-center align-middle bg-glass" id="documentTable">
        <thead class="table-light">
        <tr>
            <th>문서번호</th>
            <th>제목</th>
            <th>문서종료일</th>
            <th>기안자</th>
            <th>1차 결재</th>
            <th>2차 결재</th>
            <th>상태</th>
            <th>삭제</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>A00001</td>
            <td><a href="draftDetail?id=A00001" class="link-white">휴가신청서(5/1~5/3)</a></td>
            <td>2025-05-01</td>
            <td>동곤</td>
            <td>김부장</td>
            <td>김이사</td>
            <td><span class="badge bg-warning text-dark">1차결재 승인</span></td>
            <td><a href="draftDelete?id=A00001" class="btn btn-sm btn-outline-danger bg-glass">삭제</a></td>
        </tr>
        <tr>
            <td>A00002</td>
            <td><a href="draftDetail?id=A00002" class="link-white">지출결의서(회의비)</a></td>
            <td>2025-05-10</td>
            <td>동곤</td>
            <td>박부장</td>
            <td>대표</td>
            <td><span class="badge bg-success">2차결재 승인</span></td>
            <td>-</td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    const searchInput = document.getElementById('searchInput');
    const searchType = document.getElementById('searchType');

    searchInput.addEventListener('keyup', function () {
        const keyword = searchInput.value.toLowerCase();
        const type = searchType.value;

        const rows = document.querySelectorAll('#documentTable tbody tr');

        rows.forEach(row => {
            const titleCell = row.children[1].innerText.toLowerCase();
            const writerCell = row.children[3].innerText.toLowerCase();

            const isMatch =
                (type === 'title' && titleCell.includes(keyword)) ||
                (type === 'writer' && writerCell.includes(keyword));

            row.style.display = isMatch ? '' : 'none';
        });
    });
</script>

</body>
</html>
