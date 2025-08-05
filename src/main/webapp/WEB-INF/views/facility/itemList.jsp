<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품리스트</title>
    <style>
        body {
            background-color: #f4f6f9;
        }

        .container {
            max-width: 1200px;
            margin-top: 40px;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        .page-link {
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container  bg-white p-4 shadow rounded">
    <h2 class="mb-4">
        <i class="fa-solid fa-box-open me-2"></i> 비품 리스트
    </h2>
    <form id="searchForm" class="row g-2 align-items-center mb-4">
        <div class="col-md-5">
            <div class="form-floating">
                <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 노트북">
                <label for="keyword">비품명/공용설비ID</label>
            </div>
        </div>

        <div class="col-md-3">
            <div class="form-floating">
                <select name="rentYn" id="rentYn" class="form-select">
                    <option value="">전체</option>
                    <option value="Y">Y</option>
                    <option value="N">N</option>
                </select>
                <label for="rentYn">반납여부</label>
            </div>
        </div>

        <div class="col-md-2 d-grid">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-magnifying-glass me-1"></i> 검색
            </button>
        </div>
    </form>

    <table class="table table-bordered text-center align-middle">
        <thead class="table-light">
        <tr>
            <th>공용설비ID</th>
            <th>이름</th>
            <th>식별번호</th>
            <th>갯수</th>
            <th>반납여부</th>
            <th>예약</th>
        </tr>
        </thead>
        <tbody id="itemTable">
        </tbody>
    </table>
    <nav class="mt-4">
        <ul class="pagination justify-content-center" id="pagination">
        </ul>
    </nav>
</div>

<div class="modal fade" id="reserveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">비품 예약</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="reserveForm" action="insertFacilityRent" method="post">
                    <input type="hidden" name="startAt" id="startAt">
                    <input type="hidden" name="endAt" id="endAt">
                    <input type="hidden" name="rentalPurpose" id="rentalPurpose">
                    <input type="hidden" name="facId" id="facId">
                    <input type="hidden" name="renterId" value="${sessionScope.loginId}">
                </form>

                <p id="reserveInfo"></p>
                <label class="form-label">시작일</label>
                <input type="date" class="form-control mb-2" id="startDate">

                <label class="form-label">시작시간 (0~23)</label>
                <input type="number" class="form-control mb-3" id="startHour" min="0" max="23" placeholder="예: 9">

                <label class="form-label">종료일</label>
                <input type="date" class="form-control mb-2" id="endDate">

                <label class="form-label">종료시간 (0~23)</label>
                <input type="number" class="form-control mb-3" id="endHour" min="0" max="23" placeholder="예: 18">

                <label class="form-label">대여 목적</label>
                <input type="text" class="form-control" id="purpose">
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button class="btn btn-primary" id="reserveBtn">예약</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        // 페이지 로드 시 비품 목록을 불러옵니다.
        loadItemList(1);

        // 검색 폼 제출 시 첫 페이지를 다시 불러옵니다.
        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadItemList(1);
        });

        // 예약 버튼 클릭 이벤트
        $("#reserveBtn").on("click", function () {
            var startDate = document.getElementById("startDate").value;
            var startHour = document.getElementById("startHour").value;
            var endDate = document.getElementById("endDate").value;
            var endHour = document.getElementById("endHour").value;
            var purpose = document.getElementById("purpose").value.trim();

            if (!startDate || !endDate || startHour === "" || endHour === "" || purpose === "") {
                alert("모든 정보를 입력해주세요.");
                return;
            }

            const start = new Date(startDate + "T" + startHour.padStart(2, "0") + ":00:00");
            const end = new Date(endDate + "T" + endHour.padStart(2, "0") + ":00:00");

            if (start >= end) {
                alert("시작일시가 종료일시보다 같거나 늦을 수 없습니다.");
                return;
            }

            // *** 이 부분을 원래대로 복원했습니다. ***
            document.getElementById("startAt").value = start;
            document.getElementById("endAt").value = end;
            // **********************************
            document.getElementById("rentalPurpose").value = purpose;

            document.getElementById("reserveForm").submit();
        });
    });

    // AJAX로 비품 목록을 불러오는 함수
    function loadItemList(page) {
        const params = {
            page: page,
            keyword: $("#keyword").val(),
            rentYn: $("#rentYn").val(),
            facType: "R_03"
        };

        $.get("/api/facility/list", params, function (res) {
            if (!res.success) {
                alert(res.message);
                return;
            }
            renderTable(res.data.list);
            renderPagination(res.data.pageDto);
        });
    }

    // 테이블 내용을 동적으로 생성하는 함수
    function renderTable(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = "<tr><td colspan='6'>데이터가 없습니다.</td></tr>";
        } else {
            $.each(list, function (i, v) {
                html += "<tr>"
                    + "<td>" + v.facId + "</td>"
                    + "<td>" + v.facName + "</td>"
                    + "<td>" + v.facUid + "</td>"
                    + "<td>" + v.capacity + "</td>"
                    + "<td>" + v.rentYn + "</td>"
                    + "<td>";
                if (v.rentYn === "Y") {
                    html += "<button class='btn btn-outline-primary btn-sm' "
                        + "onclick=\"openModal('" + v.facId + "','" + v.facName + "')\">예약하기</button>";
                }
                html += "</td></tr>";
            });
        }
        $("#itemTable").html(html);
    }

    // 페이징 UI를 동적으로 생성하는 함수
    function renderPagination(p) {
        let html = "";

        // 이전 버튼
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }

        // 페이지 번호
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadItemList(" + i + ")'>" + i + "</a></li>";
        }

        // 다음 버튼
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }

        $("#pagination").html(html);
    }

    // 예약 모달을 여는 함수
    function openModal(id, model) {
        document.getElementById('reserveInfo').innerText = '공용설비ID: ' + id + ' / 비품명: ' + model;
        const modal = new bootstrap.Modal(document.getElementById('reserveModal'));
        document.querySelector("#facId").value = id;
        modal.show();
    }
</script>
</body>
</html>