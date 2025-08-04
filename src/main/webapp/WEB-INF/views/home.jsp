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
            height: 100%;
        }

        .card h5 {
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .list-group-item {
            background-color: transparent;
            border: none;
            padding: 0.5rem 0;
        }

        .table th, .table td {
            vertical-align: middle;
        }

        @media (max-width: 767px) {
            .main {
                padding: 20px;
            }
        }
        #myDraftListBody {
            cursor: pointer;
        }
        #myDraftListBody :hover {
            background-color: #f5f5f5; /* 마우스 올렸을 때 배경 하이라이트 */
        }
    </style>
</head>
<body>

<div class="main container-xl">
    <div class="row gy-4">
        <!-- 나의 결재 현황 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <h5>📄 나의 결재 현황</h5>
                <div class="table-responsive">
                    <table class="table table-sm table-hover align-middle text-center" id="myDraftTable">
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

        <!-- 나의 예약 내역 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">📅 나의 예약 내역</h5>
                    <a href="/facility/getReservationList" class="btn btn-sm btn-primary" title="예약 내역 더보기">+</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>유형</th>
                            <th>예약 명</th>
                            <th>예약기간</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="res" items="${myReservations}">
                            <tr>
                                <td>[${res.commName}]</td>
                                <td>${res.facName}</td>
                                <td>${res.startAt} ~ ${res.endAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty myReservations}">
                            <tr>
                                <td colspan="2" class="text-muted text-center">예약 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 회사 일정 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">📆 회사 일정</h5>
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
                        <tbody>
                        <c:forEach var="s" items="${scheduleList}">
                            <tr>
                                <td>${s.scheduleTitle}</td>
                                <td>${s.startAtStr} ~ ${s.endAtStr}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty scheduleList}">
                            <tr>
                                <td colspan="2" class="text-muted text-center">등록된 일정이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 최근 공지사항 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">📢 최근 공지사항</h5>
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
                        <tbody>
                        <c:forEach var="notice" items="${noticeList}">
                            <tr>
                                <td>${notice.noticeTitle}</td>
                                <td>${notice.memName}</td>
                                <td>${notice.updatedAtToStr}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty noticeList}">
                            <tr>
                                <td colspan="3" class="text-muted text-center">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>

    $(document).on("click", "#myDraftTable", function (e) {
        console.log("드래프트테이블클릭확인: ", e);

        window.location.href = "/draft/getMyDraftList";
    });

    function loadMyDraftSummary() {
        $.ajax({
            url: "/draft/getMyDraftSummary",
            type: "GET",
            dataType: "json",
            success: function(res) {
                var list = res.data || [];
                var tbody = $("#myDraftListBody");
                tbody.empty();

                if (list.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-muted">결재 문서가 없습니다.</td></tr>');
                } else {
                    $.each(list, function(i, item) {
                        var formCodeStr = item.formCodeStr || "양식 없음";
                        var docTitle = item.docTitle || "제목 없음";
                        var endDate = item.docEndDate ? item.docEndDate.substring(0, 10) : "-";
                        var statusStr = getStatusBadge(item.status);

                        tbody.append(
                            '<tr>' +
                            '<td>' + formCodeStr + '</td>' +
                            '<td class="text-truncate" style="max-width:180px;" title="' + docTitle + '">' + docTitle + '</td>' +
                            '<td>' + endDate + '</td>' +
                            '<td>' + statusStr + '</td>' +
                            '</tr>'
                        );
                    });
                }
            },
            error: function(xhr) {
                console.error("나의 결재 현황 조회 실패", xhr.responseText);
                $("#myDraftListBody").html('<tr><td colspan="4" class="text-danger">데이터를 불러오지 못했습니다.</td></tr>');
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
    $(document).ready(function() {
        loadMyDraftSummary();
    });

</script>
</body>
</html>
