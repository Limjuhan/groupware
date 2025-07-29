<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 관리 - LDBSOFT</title>
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
            padding: 20px;
        }

        .table.bg-glass th,
        .table.bg-glass td {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
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

        .form-control.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .form-control.bg-glass:focus,
        .form-select.bg-glass:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: none;
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

        .page-link.bg-glass {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
            border: none;
            border-radius: 0.3rem;
        }

        .page-link.bg-glass:hover {
            background: rgba(255, 255, 255, 0.2) !important;
        }

        .pagination .active .page-link {
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
        }

        h4 {
            /* text-shadow 제거 */
        }

        .modal-content {
            background-color: rgba(52, 58, 64, 0.9) !important;
            color: #fff !important;
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.5) !important;
        }

        .modal-header,
        .modal-footer {
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

        .name-link {
            text-decoration: underline;
            color: #e0e0e0;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .name-link:hover {
            color: #0d6efd;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 3px;
            padding: 2px 4px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEmployeeDetail(memId) {
            $.ajax({
                url: '/admin/getMemberInfo',
                method: 'GET',
                data: { memId: memId },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        const user = response.data;
                        const annualHistoryList = response.data.annualHistoryList;
                        $('#detailMemPicture').attr('src', user.memPicture || '/img/profile_default.png');
                        $('#detailName').val(user.memName);
                        $('#detailGender').val(user.memGender);
                        $('#detailBirth').val(user.birthDate);
                        $('#detailPhone').val(user.memPhone);
                        $('#detailDept').val(user.deptName);
                        $('#detailRank').val(user.rankName);
                        $('#detailStatus').val(user.memStatus);
                        $('#detailHire').val(user.memHiredate);
                        $('#detailEmail').val(user.memEmail);
                        $('#detailPrivateEmail').val(user.memPrivateEmail);
                        $('#detailAddress').val(user.memAddress);
                        const $annualInfo = $('#annualInfo');
                        $annualInfo.empty();
                        if (user.year != null && user.totalDays != null) {
                            $annualInfo.html(
                                '<strong>연도:</strong> ' + user.year + '년<br>' +
                                '<strong>총 연차:</strong> ' + user.totalDays + '일<br>' +
                                '<strong>사용 연차:</strong> ' + user.useDays + '일<br>' +
                                '<strong>잔여 연차:</strong> ' + user.remainDays + '일'
                            );
                        } else {
                            $annualInfo.html('연차 정보가 없습니다.');
                        }
                        const $annualHistoryBody = $('#annualHistoryBody');
                        $annualHistoryBody.empty();
                        if (annualHistoryList && annualHistoryList.length > 0) {
                            $.each(annualHistoryList, function(index, his) {
                                const row = '<tr>' +
                                    '<td>' + his.startDate + ' ~ ' + his.endDate + '</td>' +
                                    '<td>' + (his.approvedByName || his.approvedBy) + '</td>' +
                                    '<td>' + (his.leaveName || his.leaveCode) + '</td>' +
                                    '</tr>';
                                $annualHistoryBody.append(row);
                            });
                        } else {
                            $annualHistoryBody.append('<tr><td colspan="3" class="text-center">연차 사용 이력이 없습니다.</td></tr>');
                        }
                        new bootstrap.Modal(document.getElementById('infoModal')).show();
                    } else {
                        alert("정보를 불러오는 데 실패했습니다: " + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error: ", status, error);
                    alert("정보를 불러오는 데 실패했습니다.");
                }
            });
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
                    if (response.success) {
                        bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
                        searchMembers();
                    } else {
                        alert("수정 실패: " + response.message);
                    }
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
                success: function(data) {
                    const $tbody = $('#memberTableBody');
                    $tbody.empty();
                    const list = data.list;
                    const pagination = data.pagination;
                    if (list && list.length > 0) {
                        $.each(list, function(index, mem) {
                            const row = '<tr>' +
                                '<td>' + mem.memId + '</td>' +
                                '<td><span class="name-link" onclick="openEmployeeDetail(\'' + mem.memId + '\')">' + mem.memName + '</span></td>' +
                                '<td>' + mem.deptName + '</td>' +
                                '<td>' + mem.rankName + '</td>' +
                                '<td><button type="button" class="btn btn-sm btn-warning bg-glass me-1" onclick="openEditModal(\'' +
                                mem.memId + '\', \'' + mem.memName + '\', \'' + (mem.deptId || '') + '\', \'' + (mem.rankId || '') +
                                '\')">설정</button></td>' +
                                '</tr>';
                            $tbody.append(row);
                        });
                    } else {
                        $tbody.append('<tr><td colspan="5" class="text-center text-muted">검색 결과가 없습니다.</td></tr>');
                    }
                    const $paging = $('#paginationArea');
                    $paging.empty();
                    let html = '<nav><ul class="pagination pagination-sm">';
                    html += '<li class="page-item' + (pagination.page === 1 ? ' disabled' : '') + '">';
                    html += '<a class="page-link bg-glass" href="#" onclick="event.preventDefault();' +
                        (pagination.page > 1 ? 'searchMembers(' + (pagination.page - 1) + ');' : '') +
                        '">이전</a></li>';
                    for (let i = pagination.startPage; i <= pagination.endPage; i++) {
                        html += '<li class="page-item' + (i === pagination.page ? ' active' : '') + '">';
                        html += '<a class="page-link bg-glass" href="#" onclick="event.preventDefault();searchMembers(' + i + ');">' + i + '</a></li>';
                    }
                    html += '<li class="page-item' + (pagination.page === pagination.totalPages ? ' disabled' : '') + '">';
                    html += '<a class="page-link bg-glass" href="#" onclick="event.preventDefault();' +
                        (pagination.page < pagination.totalPages ? 'searchMembers(' + (pagination.page + 1) + ');' : '') +
                        '">다음</a></li>';
                    html += '</ul></nav>';
                    $paging.append(html);
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error: ", status, error);
                    alert('데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        $(document).ready(function() {
            searchMembers();
        });
        $(function () {
            searchMembers();

            $('#nameFilter').keypress(function (e) {
                if (e.which === 13) {
                    searchMembers(1);
                }
            });
        });
    </script>
</head>
<body>
<div class="container bg-glass p-4 rounded mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4>사원 관리</h4>
        <a href="/admin/getMemberForm" class="btn btn-primary bg-glass">등록</a>
    </div>

    <div class="row mb-3 align-items-end">
        <div class="col-md-3 select-wrapper">
            <label for="deptFilter" class="form-label">부서</label>
            <select id="deptFilter" class="form-select bg-glass custom-select-arrow">
                <option value="">전체</option>
                <c:forEach var="dept" items="${deptList}">
                    <option value="${dept.deptId}">${dept.deptName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3 select-wrapper">
            <label for="rankFilter" class="form-label">직급</label>
            <select id="rankFilter" class="form-select bg-glass custom-select-arrow">
                <option value="">전체</option>
                <c:forEach var="rank" items="${rankList}">
                    <option value="${rank.rankId}">${rank.rankName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-4">
            <label for="nameFilter" class="form-label">이름</label>
            <input type="text" id="nameFilter" class="form-control bg-glass" placeholder="검색어 입력">
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary w-100 bg-glass" onclick="searchMembers(1)">검색</button>
        </div>
    </div>

    <table class="table table-hover table-bordered text-center align-middle bg-glass">
        <thead class="table-light text-dark">
        <tr>
            <th>사원번호</th>
            <th>이름</th>
            <th>부서</th>
            <th>직급</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody id="memberTableBody"></tbody>
    </table>

    <div id="paginationArea" class="d-flex justify-content-center mt-3"></div>
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

<div class="modal fade" id="infoModal" tabindex="-1" aria-labelledby="infoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="infoModalLabel">사원 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-4">
                    <div class="col-md-3 text-center">
                        <img id="detailMemPicture" class="img-thumbnail mb-2" style="max-width:150px" alt="사원 사진">
                    </div>
                    <div class="col-md-9">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">이름</label>
                                <input id="detailName" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">성별</label>
                                <input id="detailGender" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">생년월일</label>
                                <input id="detailBirth" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">전화번호</label>
                                <input id="detailPhone" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">부서</label>
                                <input id="detailDept" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">직급</label>
                                <input id="detailRank" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">재직상태</label>
                                <input id="detailStatus" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">입사일</label>
                                <input id="detailHire" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">이메일</label>
                                <input id="detailEmail" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">2차 이메일</label>
                                <input id="detailPrivateEmail" class="form-control" readonly>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">주소</label>
                                <input id="detailAddress" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                </div>
                <h5 class="mt-4">연차 정보</h5>
                <div id="annualInfo" class="border p-3 rounded mb-3" style="background-color: rgba(255, 255, 255, 0.1); color: #fff;">
                </div>
                <table class="table table-bordered text-white">
                    <thead class="table-light text-dark">
                    <tr>
                        <th>기간</th>
                        <th>결재자</th>
                        <th>휴가 종류</th>
                    </tr>
                    </thead>
                    <tbody id="annualHistoryBody">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>