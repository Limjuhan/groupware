<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LDBSOFT 메인</title>
    <style>
        .header h4 {
            margin: 0;
            font-weight: 600;
        }

        .main {
            padding: 40px 40px;
            margin-top: 30px;
            min-height: calc(100vh - 80px); /* 화면 높이 - header */
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            height: 100%;
        }

        .card h5 {
            font-size: 1.1rem;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .list-group-item {
            border: none;
            padding: 10px 15px;
            font-size: 0.95rem;
            color: #495057;
            background-color: transparent;
        }

        @media (max-width: 767px) {
            .main {
                padding: 20px;
            }
        }

    </style>
</head>
<body>

<!-- 메인 콘텐츠 -->
<div class="main container-xl">
    <div class="row gy-4 gx-4 align-items-stretch">
        <!-- 나의 결재 현황 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4 h-100">
                <h5>📄 나의 결재 현황</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item ">[휴가신청서] - 1차 결재 대기</li>
                    <li class="list-group-item ">[지출결의서] - 결재 완료</li>
                    <li class="list-group-item ">[프로젝트제안서] - 반려</li>
                </ul>
            </div>
        </div>

        <!-- 나의 예약 내역 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4 h-100">
                <h5>📅 나의 예약 내역</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">회의실 R_02 (14:00 ~ 16:00)</li>
                    <li class="list-group-item">차량 K7 (08:00 ~ 18:00)</li>
                </ul>
            </div>
        </div>

        <!-- 회사 일정 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4 h-100">
                <h5>📆 회사 일정</h5>
                <ul class="list-group list-group-flush">
                    <c:forEach var="s" items="${scheduleList}">
                        <li class="list-group-item">
                                ${s.startAtStr} - ${s.scheduleTitle}
                        </li>
                    </c:forEach>
                    <c:if test="${empty scheduleList}">
                        <li class="list-group-item text-muted">등록된 일정이 없습니다.</li>
                    </c:if>
                </ul>
            </div>
        </div>

        <!-- 최근 공지사항 -->
        <div class="col-lg-6 col-md-12">
            <div class="card p-4 h-100">
                <h5>📢 최근 공지사항</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">✔ 시스템 점검 안내 (7/20)</li>
                    <li class="list-group-item">✔ 회의실 예약 기준 변경</li>
                </ul>
            </div>
        </div>
    </div>
</div>

</body>
</html>