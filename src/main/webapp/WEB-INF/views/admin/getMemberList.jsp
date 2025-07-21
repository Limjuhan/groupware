<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 관리</title>
    <style>
        body { background-color: transparent; }

        .container,
        .form-control,
        .form-select,
        .table-bordered,
        .table-light,
        .table-light th,
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

        .table td, .table th {
            text-align: center;
            vertical-align: middle;
            color: #fff;
        }

        .table-light th {
            color: #fff !important;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.7);
        }

        .form-select option {
            background-color: rgba(52,58,64,0.9);
            color: #fff;
        }

        .btn-outline-light {
            color: #fff;
            border-color: #fff;
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

        .modal-content {
            background-color: rgba(52, 58, 64, 0.9) !important;
            color: #fff !important;
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            box-shadow: 0 0 15px rgba(0,0,0,0.5) !important;
        }

        .modal-header, .modal-footer {
            border-color: rgba(255, 255, 255, 0.2) !important;
        }

        .modal-title {
            color: #fff !important;
        }

        .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
        }

        .modal-body .form-label {
            color: #fff !important;
        }

        .modal-body .form-control,
        .modal-body .form-select {
            background-color: rgba(255,255,255,0.1) !important;
            color: #fff !important;
            border-color: rgba(255,255,255,0.3) !important;
        }

        .modal-body .form-select option {
            background-color: #343a40 !important;
            color: #fff !important;
        }

    </style>
    <script>
        function openEmployeeDetail(empNo) {
            const url = "employeeDetail?empNo=" + empNo;
            window.open(url, "_blank", "width=800,height=600,scrollbars=yes,resizable=yes");
        }

        function openEditModal(memId, memName, deptId, rankId) {
            $('#editMemId').val(memId);
            $('#editMemIdDisplay').val(memId);
            $('#editMemName').val(memName);
            $('#editDept').val(deptId);
            $('#editRank').val(rankId);
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }

        function saveEdit() {
            const memId = $('#editMemId').val();
            const deptId = $('#editDept').val();
            const rankId = $('#editRank').val();

            $.ajax({
                url: '/admin/updateMemberByMng',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    memId: memId,
                    deptId: deptId,
                    rankId: rankId
                }),
                success: function(response) {
                    bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
                    searchMembers();
                },
                error: function(xhr) {
                    console.error("AJAX Error: ", xhr.status, xhr.responseText);
                    alert("수정 실패: " + xhr.responseText);
                }
            });
        }

        function searchMembers(page = 1) {
            const dept = $('#deptFilter').val();
            const rank = $('#rankFilter').val();
            const name = $('#nameFilter').val().trim();

            $.ajax({
                url: '/admin/searchMembers',
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
                                '<td><button type="button" class="btn btn-sm btn-outline-primary" onclick="openEditModal(\'' +
                                mem.memId + '\', \'' + mem.memName + '\', \'' + (mem.deptId || '') + '\', \'' + (mem.rankId || '') +
                                '\')">설정</button></td>' +
                                '</tr>';
                            $tbody.append(row);
                        });
                    } else {
                        $tbody.append('<tr><td colspan="6" class="text-center text-muted">검색 결과가 없습니다.</td></tr>');
                    }

                    const $paging = $('#paginationArea');
                    $paging.empty();

                    let html = '<nav><ul class="pagination justify-content-center">';
                    html += '<li class="page-item' + (pagination.page === 1 ? ' disabled' : '') + '">';
                    html += '<a class="page-link" href="#" onclick="event.preventDefault();' +
                        (pagination.page > 1 ? 'searchMembers(' + (pagination.page - 1) + ');' : '') +
                        '">이전</a></li>';

                    for (let i = pagination.startPage; i <= pagination.endPage; i++) {
                        html += '<li class="page-item' + (i === pagination.page ? ' active' : '') + '">';
                        html += '<a class="page-link" href="#" onclick="event.preventDefault();searchMembers(' + i + ');">' + i + '</a></li>';
                    }

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
                    <option value="${dept.deptId}">${dept.deptName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label">직급</label>
            <select id="rankFilter" class="form-select">
                <option value="">전체</option>
                <c:forEach var="rank" items="${rankList}">
                    <option value="${rank.rankId}">${rank.rankName}</option>
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
        <a href="/admin/getMemberForm" class="btn btn-success btn-sm">+ 등록</a>
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

<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">사원 설정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editMemId">

                <div class="mb-3">
                    <label class="form-label">사원번호</label>
                    <input type="text" id="editMemIdDisplay" class="form-control" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">사원 이름</label>
                    <input type="text" id="editMemName" class="form-control" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">부서</label>
                    <select id="editDept" class="form-select">
                        <c:forEach var="dept" items="${deptList}">
                            <option value="${dept.deptId}">${dept.deptName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">직급</label>
                    <select id="editRank" class="form-select">
                        <c:forEach var="rank" items="${rankList}">
                            <option value="${rank.rankId}">${rank.rankName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" onclick="saveEdit()">저장</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>