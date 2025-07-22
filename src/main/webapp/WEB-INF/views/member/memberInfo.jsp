<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>개인정보</title>
    <style>
        body {
            background-color: #f4f6f9;
            color: white;
        }

        .container {
            max-width: 900px;
            margin-top: 40px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
        }

        .img-thumbnail {
            max-width: 150px;
        }

        .form-label {
            font-weight: bold;
        }

        .form-control.bg-light, .form-select.bg-light {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: white !important;
            border-color: rgba(255, 255, 255, 0.3);
        }

        .form-control {
            color: white;
            border-color: rgba(255, 255, 255, 0.3);
            background-color: rgba(255, 255, 255, 0.15);
        }
    </style>
    <script>
        function getPassEditForm() {
            let op = "width=500,height=600,top=100,left=300,resizable=no,scrollbars=no";
            window.open("/member/passEditForm", "비밀번호변경", op);
        }
    </script>
</head>
<body>
<div class="container shadow rounded">
    <h2 class="mb-4">개인정보</h2>
    <form method="post" action="updateMemberInfo" enctype="multipart/form-data">
        <div class="row mb-4">
            <div class="col-md-3 text-center">
                <img src="${not empty user.memPicture ? user.memPicture : '/img/profile_default.png'}" alt="사원 사진"
                     class="img-thumbnail mb-2">
                <input type="file" class="form-control" name="photo">
            </div>
            <div class="col-md-9">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-control bg-light" name="name" value="${user.memName}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">성별</label>
                        <select class="form-select bg-light" name="gender" disabled>
                            <option value="남" ${user.memGender == '남' ? 'selected' : ''}>남</option>
                            <option value="여" ${user.memGender == '여' ? 'selected' : ''}>여</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">생년월일</label>
                        <input type="date" class="form-control bg-light" name="birthDate" value="${user.birthDate}"
                               readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">전화번호*</label>
                        <input type="text" class="form-control" name="phone" value="${user.memPhone}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">부서</label>
                        <input type="text" class="form-control bg-light" name="department" value="${user.deptName}"
                               readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">직급</label>
                        <input type="text" class="form-control bg-light" name="position" value="${user.rankName}"
                               readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">재직상태</label>
                        <input type="text" class="form-control bg-light" name="status" value="${user.memStatus}"
                               readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">입사일</label>
                        <input type="date" class="form-control bg-light" name="hireDate" value="${user.memHiredate}" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">이메일</label>
                        <input type="email" class="form-control bg-light" name="email" value="${user.memEmail}"
                               readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">2차 이메일</label>
                        <input type="email" class="form-control" name="privateEmail" value="${user.memPrivateEmail}">
                    </div>
                    <div class="col-md-12">
                        <label class="form-label">주소*</label>
                        <input type="text" class="form-control" name="address" value="${user.memAddress}">
                    </div>
                </div>
            </div>
        </div>
        <!-- ✅ 연차 정보 (나중에 연동 가능) -->
        <h5 class="section-title">연차 정보</h5>
        <div class="row mb-3">
            <div class="col-md-4">
                <div class="border p-3 bg-light text-dark rounded">
                    <strong>총 연차:</strong> 15일<br>
                    <strong>사용 연차:</strong> 6일<br>
                    <strong>잔여 연차:</strong> 9일
                </div>
            </div>
        </div>

        <h6 class="mt-3">연차 사용 내역</h6>
        <table class="table table-bordered text-white">
            <thead class="table-light text-dark">
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
            <button type="button" class="btn btn-warning me-2" onclick="getPassEditForm()">비밀번호 변경</button>
            <button type="submit" class="btn btn-primary">저장</button>
            <button type="reset" class="btn btn-outline-light">↺ 되돌리기</button>
        </div>
    </form>
</div>
</body>
</html>
