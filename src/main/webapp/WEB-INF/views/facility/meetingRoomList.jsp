<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>회의실 예약리스트 - LDBSOFT 그룹웨어</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

        /* 회의실명 */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 25%;
        }

        /* 식별번호 */
        .table th:nth-child(4), .table td:nth-child(4) {
            width: 10%;
        }

        /* 수용인원 */
        .table th:nth-child(5), .table td:nth-child(5) {
            width: 20%;
        }

        /* 예약 */
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">🏢 회의실 리스트</h2>

    <form id="searchForm" class="row mb-4 g-2 align-items-end">
        <div class="col-md-5">
            <label for="keyword" class="form-label fw-medium">회의실명 / 공용설비ID</label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="예: 회의실205호">
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
            <th>회의실명</th>
            <th>식별번호</th>
            <th>수용인원</th>
            <th>예약</th>
        </tr>
        </thead>
        <tbody id="meetingRoomTable">
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
                <h5 class="modal-title">회의실 예약</h5>
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
        // 페이지 로드 시 회의실 목록 불러오기
        loadMeetingRoomList(1);

        // 검색 폼 제출 시 첫 페이지 로드
        $("#searchForm").on("submit", function (e) {
            e.preventDefault();
            loadMeetingRoomList(1);
        });

        // 예약 버튼 클릭 이벤트
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

    function loadMeetingRoomList(page) {
        const params = {
            page: page,
            keyword: $("#keyword").val(),
            rentYn: $("#rentYn").val(),
            facType: "R_02"
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
        $("#meetingRoomTable").html(html);
    }

    function renderPagination(p) {
        let html = "";
        if (p.page > 1) {
            html += "<li class='page-item'><a class='page-link' onclick='loadMeetingRoomList(" + (p.page - 1) + ")'>이전</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>이전</span></li>";
        }
        for (let i = p.startPage; i <= p.endPage; i++) {
            html += "<li class='page-item " + (i === p.page ? "active" : "") + "'>"
                + "<a class='page-link' onclick='loadMeetingRoomList(" + i + ")'>" + i + "</a></li>";
        }
        if (p.page < p.totalPages) {
            html += "<li class='page-item'><a class='page-link' onclick='loadMeetingRoomList(" + (p.page + 1) + ")'>다음</a></li>";
        } else {
            html += "<li class='page-item disabled'><span class='page-link'>다음</span></li>";
        }
        $("#pagination").html(html);
    }

    function openModal(id, model) {
        $("#reserveInfo").text("공용설비ID: " + id + " / 회의실명: " + model);
        $("#facId").val(id);
        new bootstrap.Modal($("#reserveModal")).show();
    }
</script>
</body>
</html>