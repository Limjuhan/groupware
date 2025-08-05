<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LDBSOFT 메인</title>
    <style>
        .main {
            padding: 40px;
            margin-top: 30px;
            min-height: calc(100vh - 80px);
        }

        .card {
            border-radius: 0.75rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.08);
            min-height: 300px;
            display: flex;
            flex-direction: column;
        }

        /* 모든 카드 헤더에 적용할 새로운 클래스 */
        .card-header-main {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 40px; /* 헤더의 높이를 고정하여 모든 카드가 동일한 높이를 갖도록 함 */
            margin-bottom: 1.5rem; /* 헤더 아래쪽 여백을 통일 (Bootstrap mb-4와 동일) */
        }

        .card-header-main h5 {
            font-weight: 600;
            margin-bottom: 0; /* 제목의 기본 마진을 제거하여 컨테이너에 완벽하게 정렬 */
        }

        .list-group-item {
            background-color: transparent;
            border: none;
            padding: 0.5rem 0;
        }

        .table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
            padding: 12px;
            height: 48px;
        }

        .table-responsive {
            flex-grow: 1;
            overflow-y: auto;
        }

        #myDraftTable tbody td:nth-child(2) {
            max-width: 180px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        #myReservationTable tbody td:nth-child(1) {
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        @media (max-width: 767px) {
            .main {
                padding: 20px;
            }

            .card {
                min-height: 250px;
            }
        }

        #myDraftListBody {
            cursor: pointer;
        }

        #myDraftListBody tr:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>

<div class="main container-xl">
    <div class="row gy-4">
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="card-header-main">
                    <h5>📄 나의 결재 현황</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center" id="myDraftTable">
                        <thead class="table-light">
                        <tr>
                            <th style="width: 20%;">양식</th>
                            <th style="width: 35%;">제목</th>
                            <th style="width: 25%;">문서 종료일</th>
                            <th style="width: 20%;">상태</th>
                        </tr>
                        </thead>
                        <tbody id="myDraftListBody">
                        <tr>
                            <td colspan="4" class="text-muted">불러오는 중...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="card-header-main">
                    <h5>📅 나의 예약 내역</h5>
                    <a href="/facility/getReservationList" class="btn btn-sm btn-primary" title="예약 내역 더보기">+</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle" id="myReservationTable">
                        <thead class="table-light">
                        <tr>
                            <th>유형</th>
                            <th>품목명</th>
                            <th>예약기간</th>
                        </tr>
                        </thead>
                        <tbody id="myReservationListBody">
                        <tr>
                            <td colspan="3" class="text-muted text-center">불러오는 중...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="card-header-main">
                    <h5>📆 회사 일정</h5>
                    <a href="/calendar/getCalendar" class="btn btn-sm btn-primary" title="일정 더보기">+</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>일정 명</th>
                            <th>일정 기간</th>
                        </tr>
                        </thead>
                        <tbody id="myScheduleListBody">
                        <tr>
                            <td colspan="2" class="text-muted text-center">불러오는 중...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="card-header-main">
                    <h5>📢 최근 공지사항</h5>
                    <a href="/board/getNoticeList" class="btn btn-sm btn-primary" title="공지사항 더보기">+</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                        </tr>
                        </thead>
                        <tbody id="myNoticeListBody">
                        <tr>
                            <td colspan="3" class="text-muted text-center">불러오는 중...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // '나의 결재 현황' 테이블 클릭 이벤트는 그대로 유지합니다.
    $(document).on("click", "#myDraftTable", function (e) {
        console.log("드래프트테이블클릭확인: ", e);
        window.location.href = "/draft/getMyDraftList";
    });

    // 나의 결재 현황 불러오기
    function loadMyDraftSummary() {
        $.ajax({
            url: "/draft/getMyDraftSummary",
            type: "GET",
            dataType: "json",
            success: function (res) {
                var list = res.data || [];
                var tbody = $("#myDraftListBody");
                tbody.empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-muted">결재 문서가 없습니다.</td></tr>');
                } else {
                    $.each(list, function (i, item) {
                        var formCodeStr = item.formCodeStr || "양식 없음";
                        var docTitle = item.docTitle || "제목 없음";
                        var endDate = item.docEndDate ? item.docEndDate.substring(0, 10) : "-";
                        var statusStr = getStatusBadge(item.status);

                        tbody.append(
                            '<tr>' +
                            '<td>' + formCodeStr + '</td>' +
                            '<td title="' + docTitle + '">' + docTitle + '</td>' +
                            '<td>' + endDate + '</td>' +
                            '<td>' + statusStr + '</td>' +
                            '</tr>'
                        );
                    });
                }
            },
            error: function (xhr) {
                console.error("나의 결재 현황 조회 실패", xhr.responseText);
                $("#myDraftListBody").html('<tr><td colspan="4" class="text-danger">데이터를 불러오지 못했습니다.</td></tr>');
            }
        });
    }

    // 나의 예약 내역 불러오기
    function loadMyReservationSummary() {
        $.ajax({
            url: "/api/facility/getMyReservationSummary",
            type: "GET",
            dataType: "json",
            success: function (res) {
                var list = res.data || [];
                var tbody = $("#myReservationListBody");
                tbody.empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="3" class="text-muted text-center">예약 내역이 없습니다.</td></tr>');
                } else {
                    $.each(list, function (i, item) {
                        var commName = item.commName || "유형 없음";
                        var facName = item.facName || "제목 없음";
                        var endDate = item.docEndDate ? item.docEndDate.substring(0, 10) : "-";
                        var statusStr = getStatusBadge(item.status);
                        tbody.append(
                            '<tr>' +
                            '<td>[' + item.commName + ']</td>' +
                            '<td>' + item.facName + '</td>' +
                            '<td>' + item.startAt + ' ~ ' + item.endAt + '</td>' +
                            '</tr>'
                        );
                    });
                }
            },
            error: function (xhr) {
                console.error("나의 예약 내역 조회 실패", xhr.responseText);
                $("#myReservationListBody").html('<tr><td colspan="3" class="text-danger text-center">데이터를 불러오지 못했습니다.</td></tr>');
            }
        });
    }

    // 회사 일정 불러오기
    function loadScheduleSummary() {
        $.ajax({
            url: "/calendar/getScheduleSummary",
            type: "GET",
            dataType: "json",
            success: function (res) {
                var list = res.data || [];
                var tbody = $("#myScheduleListBody");
                tbody.empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="2" class="text-muted text-center">등록된 일정이 없습니다.</td></tr>');
                } else {
                    $.each(list, function (i, item) {
                        tbody.append(
                            '<tr>' +
                            '<td>' + item.scheduleTitle + '</td>' +
                            '<td>' + item.startAtStr + ' ~ ' + item.endAtStr + '</td>' +
                            '</tr>'
                        );
                    });
                }
            },
            error: function (xhr) {
                console.error("회사 일정 조회 실패", xhr.responseText);
                $("#myScheduleListBody").html('<tr><td colspan="2" class="text-danger text-center">데이터를 불러오지 못했습니다.</td></tr>');
            }
        });
    }

    // 최근 공지사항 불러오기
    function loadNoticeSummary() {
        $.ajax({
            url: "/api/notice/getNoticeSummary",
            type: "GET",
            dataType: "json",
            success: function (res) {
                var list = res.data.notice || [];
                var tbody = $("#myNoticeListBody");
                tbody.empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="3" class="text-muted text-center">등록된 공지사항이 없습니다.</td></tr>');
                } else {
                    $.each(list, function (i, item) {
                        tbody.append(
                            '<tr>' +
                            '<td>' + item.noticeTitle + '</td>' +
                            '<td>' + item.memName + '</td>' +
                            '<td>' + item.updatedAtToStr + '</td>' +
                            '</tr>'
                        );
                    });
                }
            },
            error: function (xhr) {
                console.error("최근 공지사항 조회 실패", xhr.responseText);
                $("#myNoticeListBody").html('<tr><td colspan="3" class="text-danger text-center">데이터를 불러오지 못했습니다.</td></tr>');
            }
        });
    }

    // 상태 뱃지 함수
    function getStatusBadge(status) {
        if (status === "0") {
            return "<span class='badge bg-secondary'>임시저장</span>";
        } else if (status === "1") {
            return "<span class='badge bg-warning text-dark'>1차결재 대기</span>";
        } else if (status === "2") {
            return "<span class='badge bg-warning text-dark'>1차결재 승인</span>";
        } else if (status === "3") {
            return "<span class='badge bg-danger'>1차결재 반려</span>";
        } else if (status === "4") {
            return "<span class='badge bg-info text-dark'>2차결재 대기</span>";
        } else if (status === "5") {
            return "<span class='badge bg-success'>2차결재 승인</span>";
        } else if (status === "6") {
            return "<span class='badge bg-danger'>2차결재 반려</span>";
        } else {
            return "<span class='badge bg-dark'>알 수 없음</span>";
        }
    }

    // 페이지 로드 시 자동 실행
    $(document).ready(function () {
        loadMyDraftSummary();
        loadMyReservationSummary();
        loadScheduleSummary();
        loadNoticeSummary();
    });
</script>
</body>
</html>