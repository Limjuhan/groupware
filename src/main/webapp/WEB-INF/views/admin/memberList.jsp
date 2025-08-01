<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 관리 - LDBSOFT</title>
    <style>
        /* 클릭 가능한 이름 스타일 */
        .name-link {
            text-decoration: underline;
            color: #0d6efd;
            cursor: pointer;
        }

        .name-link:hover {
            color: #0a58ca;
        }

        /* 테이블 호버 효과 */
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* 페이지네이션 스타일 커스터마이징 */
        .pagination .page-link {
            border-radius: 0.375rem;
            margin: 0 0.125rem;
        }

        .pagination .page-item.active .page-link {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        .pagination .page-item.disabled .page-link {
            background-color: #f8f9fa;
            color: #6c757d;
        }
    </style>
    <script>
        function openEmployeeDetail(memId) {
            $.ajax({
                url: '/admin/getMemberInfo',
                method: 'GET',
                data: {memId: memId},
                dataType: 'json',
                success: function (response) {
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
                        $('#detailStatus').val(user.statusStr);
                        $('#detailHire').val(user.memHiredate);
                        $('#detailEmail').val(user.memEmail);
                        $('#detailPrivateEmail').val(user.privateEmail);
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
                            $.each(annualHistoryList, function (index, his) {
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
                error: function (xhr, status, error) {
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
                success: function (response) {
                    if (response.success) {
                        bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
                        searchMembers();
                    } else {
                        alert("수정 실패: " + response.message);
                    }
                },
                error: function (xhr) {
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
                                '<td><button type="button" class="btn btn-sm btn-warning" onclick="openEditModal(\'' +
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
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0">사원 관리</h4>
        <a href="/admin/getMemberForm" class="btn btn-primary">등록</a>
    </div>

    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <label for="deptFilter" class="form-label fw-medium">부서</label>
            <select id="deptFilter" class="form-select rounded">
                <option value="">전체</option>
                <c:forEach var="dept" items="${deptList}">
                    <option value="${dept.deptId}">${dept.deptName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3 mb-3">
            <label for="rankFilter" class="form-label fw-medium">직급</label>
            <select id="rankFilter" class="form-select rounded">
                <option value="">전체</option>
                <c:forEach var="rank" items="${rankList}">
                    <option value="${rank.rankId}">${rank.rankName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-4 mb-3">
            <label for="nameFilter" class="form-label fw-medium">이름</label>
            <input type="text" id="nameFilter" class="form-control rounded" placeholder="검색어 입력">
        </div>
        <div class="col-md-2 mb-3 d-flex align-items-end">
            <button class="btn btn-primary w-100 rounded" onclick="searchMembers(1)">검색</button>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover table-bordered text-center mb-0">
                <thead class="table-light">
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
        </div>
    </div>

    <div id="paginationArea" class="d-flex justify-content-center mt-4"></div>
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
                    <label class="form-label fw-medium">사원번호</label>
                    <input type="text" id="editMemIdDisplay" class="form-control bg-light" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium">사원 이름</label>
                    <input type="text" id="editMemName" class="form-control bg-light" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium">부서</label>
                    <select id="editDept" class="form-select">
                        <c:forEach var="dept" items="${deptList}">
                            <option value="${dept.deptId}">${dept.deptName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-medium">직급</label>
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
                                <label class="form-label fw-medium">이름</label>
                                <input id="detailName" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">성별</label>
                                <input id="detailGender" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">생년월일</label>
                                <input id="detailBirth" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">전화번호</label>
                                <input id="detailPhone" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">부서</label>
                                <input id="detailDept" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">직급</label>
                                <input id="detailRank" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">재직상태</label>
                                <input id="detailStatus" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">입사일</label>
                                <input id="detailHire" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">이메일</label>
                                <input id="detailEmail" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-medium">2차 이메일</label>
                                <input id="detailPrivateEmail" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label fw-medium">주소</label>
                                <input id="detailAddress" class="form-control bg-light" readonly>
                            </div>
                        </div>
                    </div>
                </div>
                <h5 class="mt-4">연차 정보</h5>
                <div id="annualInfo" class="border p-3 rounded mb-3 bg-light"></div>
                <table class="table table-bordered">
                    <thead class="table-light">
                    <tr>
                        <th>기간</th>
                        <th>결재자</th>
                        <th>휴가 종류</th>
                    </tr>
                    </thead>
                    <tbody id="annualHistoryBody"></tbody>
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