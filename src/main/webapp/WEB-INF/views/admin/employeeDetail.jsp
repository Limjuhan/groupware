<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 상세정보 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 1000px;
            margin-top: 40px;
        }
        .section-title {
            margin-top: 40px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        .profile-img {
            max-width: 150px;
        }
    </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
    <h2 class="mb-4">사원 상세정보</h2>

    <!-- 1. 기본정보 -->
    <h5 class="section-title">기본정보</h5>
    <div class="row mb-4">
        <div class="col-md-3 text-center">
            <img src="profile_default.png" alt="사원 사진" class="img-thumbnail profile-img">
        </div>
        <div class="col-md-9">
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <th>이름</th><td>동곤</td>
                        <th>이메일</th><td>donggon@ldbsoft.co.kr</td>
                    </tr>
                    <tr>
                        <th>전화번호</th><td>010-1234-5678</td>
                        <th>부서</th><td>개발팀</td>
                    </tr>
                    <tr>
                        <th>직급</th><td>대리</td>
                        <th>입사일</th><td>2021-03-01</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

<!--     2. 근태정보
    <h5 class="section-title">근태 정보</h5>
    <div class="row mb-3">
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>출근</h6>
                    <p class="fs-4">180</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>지각</h6>
                    <p class="fs-4">4</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>결근</h6>
                    <p class="fs-4">2</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <h6>조퇴</h6>
                    <p class="fs-4">1</p>
                </div>
            </div>
        </div>
    </div> -->

    <!-- 3. 연차 정보 -->
    <h5 class="section-title">연차 정보</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <div class="border p-3 bg-light">
                <strong>총 연차:</strong> 15일<br>
                <strong>사용 연차:</strong> 6일<br>
                <strong>잔여 연차:</strong> 9일
            </div>
        </div>
    </div>

    <h6 class="mt-3">연차 사용 내역</h6>
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>기간</th>
                <th>결재자</th>
                <th>휴가 종류</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>2025-01-15 ~ 2025-01-16</td>
                <td>김이사</td>
                <td>연차</td>
            </tr>
            <tr>
                <td>2025-05-03</td>
                <td>김이사</td>
                <td>오전 반차</td>
            </tr>
        </tbody>
    </table>

    <div class="text-end">
        <a href="javascript:window.close()" class="btn btn-secondary">닫기</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
