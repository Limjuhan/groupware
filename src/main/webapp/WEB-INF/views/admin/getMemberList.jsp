<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 관리</title>
    <style>
        body { background-color: transparent; }
        .container, .form-control, .form-select,
        .table-bordered, .table-light, .table-light th,
        .table-bordered tbody td {
            background-color: rgba(255,255,255,0.1);
            color: #fff;
            border-color: rgba(255,255,255,0.3);
        }
        .form-control, .form-select {
            background-color: rgba(255,255,255,0.1) !important;
            border-color: rgba(255,255,255,0.3) !important;
            color: #fff !important;
        }
        .form-control::placeholder { color: #ccc; }
        .table td, .table th { text-align: center; vertical-align: middle; color: #fff; }
        .table-light th {
            color: #fff !important;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.7);
        }
        .name-link {
            color: #0d6efd;
            text-decoration: underline;
            cursor: pointer;
        }
        h4 { color: #fff; text-shadow: 1px 1px 3px rgba(0,0,0,0.7); }
        .form-select option {
            background-color: rgba(52,58,64,0.9);
            color: #fff;
        }
        .btn-outline-light {
            color: #fff; border-color: #fff;
        }
        .btn-outline-light:hover {
            background-color: rgba(255,255,255,0.2);
        }
        .btn-success {
            background-color: #198754;
            border-color: #198754;
            color: #fff;
        }
        .btn-success:hover {
            background-color: #157347;
            border-color: #146c43;
        }
        .pagination-nav {
            margin-top: 20px;
            text-align: center;
        }
        .pagination-nav .page-link {
            color: white;
            background-color: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.3);
            margin: 0 2px;
            padding: 6px 12px;
        }
        .pagination-nav .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
            font-weight: bold;
        }
        .pagination-nav .page-item.disabled .page-link {
            pointer-events: none;
            opacity: 0.5;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        function openEmployeeDetail(empNo) {
            const url = "employeeDetail?empNo=" + empNo;
            window.open(url, "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
        }

        function searchMembers(page = 1) {
            const dept = $('#deptFilter').val();
            const rank = $('#rankFilter').val();
            const name = $('#nameFilter').val().trim();

            $.ajax({
                url: '/member/searchMembers',
                method: 'GET',
                data: {
                    dept: dept,
                    rank: rank,
                    name: name,
                    page: page
                },
                dataType: 'json',
                success: function (data) {
                    const $tbody = $('#memberTableBody');
                    $tbody.empty();

                    const list = data.list;
                    const pagination = data.pagination;

                    if (list && list.length > 0) {
                        $.each(list, function (index, mem) {
                            const row = '<tr>' +
                                '<td>' + mem.memId + '</td>' +
                                '<td><span class="name-link" onclick="openEmployeeDetail(\'' + mem.memId + '\')">' + mem.memName + '</span></td>' +
                                '<td>' + mem.deptName + '</td>' +
                                '<td>' + mem.rankName + '</td>' +
                                '<td>' + (mem.memLevel ?? '-') + '</td>' +
                                '<td><a href="memberInfoUpdate?empNo=' + mem.memId + '" class="btn btn-sm btn-outline-primary">설정</a></td>' +
                                '</tr>';
                            $tbody.append(row);
                        });
                    } else {
                        $tbody.append('<tr><td colspan="6" class="text-center text-muted">검색 결과가 없습니다.</td></tr>');
                    }

                    // 페이징 영역
                    const $paging = $('#paginationArea');
                    $paging.empty();

                    let html = '<nav><ul class="pagination justify-content-center">';

                    // 이전 버튼
                    html += '<li class="page-item' + (pagination.page === 1 ? ' disabled' : '') + '">';
                    html += '<a class="page-link" href="#" onclick="event.preventDefault();' +
                        (pagination.page > 1 ? 'searchMembers(' + (pagination.page - 1) + ');' : '') +
                        '">이전</a></li>';

                    // 페이지 번호
                    for (let i = pagination.startPage; i <= pagination.endPage; i++) {
                        html += '<li class="page-item' + (i === pagination.page ? ' active' : '') + '">';
                        html += '<a class="page-link" href="#" onclick="event.preventDefault();searchMembers(' + i + ');">' + i + '</a></li>';
                    }

                    // 다음 버튼
                    html += '<li class="page-item' + (pagination.page === pagination.totalPages ? ' disabled' : '') + '">';
                    html += '<a class="page-link" href="#" onclick="event.preventDefault();' +
                        (pagination.page < pagination.totalPages ? 'searchMembers(' + (pagination.page + 1) + ');' : '') +
                        '">다음</a></li>';

                    html += '</ul></nav>';
                    $paging.append(html);
                },
                error: function (xhr, status, error) {
                    console.error("AJAX Error: ", status, error);
                    alert('데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        $(document).ready(function () {
            searchMembers();
        });
    </script>
</head>
<body>
<div class="container shadow-sm rounded">
    <h4 class="mb-4 fw-bold">👤 사원 관리</h4>

    <form class="row g-3 mb-4" onsubmit="event.preventDefault(); searchMembers();">
        <div class="col-md-3">
            <label class="form-label">부서</label>
            <select id="deptFilter" class="form-select">
                <option value="">전체</option>
                <c:forEach var="dept" items="${deptList}">
                    <option value="${dept}">${dept}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label">직급</label>
            <select id="rankFilter" class="form-select">
                <option value="">전체</option>
                <c:forEach var="rank" items="${rankList}">
                    <option value="${rank}">${rank}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">이름</label>
            <input type="text" id="nameFilter" class="form-control" placeholder="이름 입력 (예: 동곤)">
        </div>
        <div class="col-md-2 d-flex align-items-end">
            <button type="submit" class="btn btn-outline-light w-100">검색</button>
        </div>
    </form>

    <div class="text-end mb-3">
        <a href="/member/getMemberForm" class="btn btn-success btn-sm">+ 등록</a>
    </div>

    <table class="table table-bordered mt-3">
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
        <tbody id="memberTableBody"></tbody>
    </table>

    <div id="paginationArea" class="pagination-nav"></div>
</div>
</body>
</html>
