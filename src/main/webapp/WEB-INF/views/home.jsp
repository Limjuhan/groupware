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
    </style>
</head>
<body>

<div class="main container-xl">
    <div class="row gy-4">
        <!-- 나의 결재 현황 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4">
                <h5>📄 나의 결재 현황</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">[휴가신청서] - 1차 결재 대기</li>
                    <li class="list-group-item">[지출결의서] - 결재 완료</li>
                    <li class="list-group-item">[프로젝트제안서] - 반려</li>
                </ul>
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

</body>
</html>
