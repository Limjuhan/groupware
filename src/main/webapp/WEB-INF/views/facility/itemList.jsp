<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품 리스트</title>
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

        /* 테이블 컬럼 너비 고정 */
        .table th:nth-child(1), .table td:nth-child(1) {
            width: 15%;
        }

        /* 공용설비ID */
        .table th:nth-child(2), .table td:nth-child(2) {
            width: 30%;
        }

        /* 비품명 */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 25%;
        }

        /* 식별번호 */
        .table th:nth-child(4), .table td:nth-child(4) {
            width: 10%;
        }

        /* 수량 */
        .table th:nth-child(5), .table td:nth-child(5) {
            width: 20%;
        }

        .page-content {
            width: 100%;
            min-height: calc(100vh - 160px);
            display: flex;
            flex-direction: column;
            background-color: #fff;
            padding: 20px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
<div class="page-content">
    <h2 class="mb-4">
        <i class="fa-solid fa-box-open me-2"></i> 비품 리스트
    </h2>

    <form id="searchForm" class="row mb-4 g-2 align-items-end">
        <div class="col-md-5">
            <label for="keyword" class="form-label fw-medium">비품명 / 공용설비ID</label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 노트북">
        </div>
        <div class="col-md-3">
            <label for="rentYn" class="form-label fw-medium">반납 여부</label>
            <select name="rentYn" id="rentYn" class="form-select">
                <option value="">전체</option>
                <option value="Y">Y</option>
                <option value="N">N</option>
            </select>
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
            <th>비품명</th>
            <th>식별번호</th>
            <th>수량</th>
            <th>예약</th>
        </tr>
        </thead>
        <tbody id="itemTable">
        </tbody>
    </table>

    <nav class="mt-4">
        <ul class="pagination justify-content-center" id="pagination"></ul>
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
        loadItemList(1);

        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadItemList(1);
        });

        $("#reserveBtn").on("click", function () {
            var startDate = $("#startDate").val();
            var startHour = $("#startHour").val();
            var endDate = $("#endDate").val();
            var endHour = $("#endHour").val();
            var purpose = $("#purpose").val().trim();

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

            $("#startAt").val(start);
            $("#endAt").val(end);
            $("#rentalPurpose").val(purpose);

            $("#reserveForm").submit();
        });
    });

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

    function renderTable(list) {
        let html = "";
        if (!list || list.length === 0) {
            html = "<tr><td colspan='5'>데이터가 없습니다.</td></tr>";
        } else {
            $.each(list, function (i, v) {
                html += "<tr>"
                    + "<td>" + v.facId + "</td>"
                    + "<td>" + v.facName + "</td>"
                    + "<td>" + v.facUid + "</td>"
                    + "<td>" + v.capacity + "</td>"
                    + "<td>";
                if (v.rentYn === "Y") {
                    html += "<button class='btn btn-outline-primary btn-sm' "
                        + "onclick=\"openModal('" + v.facId + "','" + v.facName + "')\">예약하기</button>";
                } else {
                    html += "-";
                }
                html += "</td></tr>";
            });
        }
        $("#itemTable").html(html);
    }

    function renderPagination(p) {
        let html = "";
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadItemList(" + i + ")'>" + i + "</a></li>";
        }
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadItemList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }
        $("#pagination").html(html);
    }

    function openModal(id, model) {
        $("#reserveInfo").text("공용설비ID: " + id + " / 비품명: " + model);
        $("#facId").val(id);
        new bootstrap.Modal($("#reserveModal")).show();
    }
</script>
</body>
</html>