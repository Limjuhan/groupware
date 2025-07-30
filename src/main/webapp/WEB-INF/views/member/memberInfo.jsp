<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인정보 - LDBSOFT</title>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 900px;
            margin-top: 2rem;
        }

        .card {
            border-radius: 0.375rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-label {
            font-weight: 500;
        }

        .form-control, .form-select {
            border-radius: 0.375rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .form-control[readonly], .form-select[disabled] {
            background-color: #e9ecef;
            opacity: 1;
        }

        .editable-field {
            background-color: #ffffff;
            border-color: #0d6efd;
        }

        .img-thumbnail {
            max-width: 150px;
            border-radius: 0.375rem;
        }

        .semi-box {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 15px;
            background-color: #ffffff;
        }

        .annual-table th, .annual-table td {
            border: 1px solid #dee2e6;
        }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>
    <script>
        function getPassEditForm() {
            let op = "width=500,height=600,top=100,left=300,resizable=no,scrollbars=no";
            window.open("/member/passEditForm", "비밀번호변경", op);
        }

        function removePhoto() {
            if (confirm("사진을 삭제하시겠습니까?")) {
                document.getElementById("profileImg").src = "/img/profile_default.png";
                document.getElementById("deletePhoto").value = "${user.memPictureSavedName}";
                const fileInput = document.getElementById("photoInput");
                if (fileInput) fileInput.value = "";
            }
        }

        window.addEventListener("DOMContentLoaded", function () {
            document.getElementById('photoInput').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (ev) {
                        document.getElementById('profileImg').src = ev.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            });
        });
    </script>
</head>
<body>
<div class="container">
    <div class="card p-4">
        <h2 class="mb-4 fw-bold">개인정보</h2>
        <form:form method="post" action="updateMemberInfo" modelAttribute="user" enctype="multipart/form-data">
            <div class="row mb-4">
                <div class="col-md-3 text-center">
                    <img id="profileImg" src="${not empty user.memPicture ? user.memPicture : '/img/profile_default.png'}"
                         alt="사원 사진" class="img-thumbnail mb-2">
                    <button type="button" class="btn btn-sm btn-outline-danger mt-2" onclick="removePhoto()">사진 삭제</button>
                    <input type="file" name="photo" class="form-control form-control-sm" id="photoInput"/>
                    <input type="hidden" name="deletePhoto" id="deletePhoto" value="N">
                </div>
                <div class="col-md-9">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">이름</label>
                            <input type="text" class="form-control" value="${user.memName}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">성별</label>
                            <select class="form-select" disabled>
                                <option value="남" ${user.memGender == '남' ? 'selected' : ''}>남</option>
                                <option value="여" ${user.memGender == '여' ? 'selected' : ''}>여</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">생년월일</label>
                            <input type="date" class="form-control" value="${user.birthDate}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">전화번호</label>
                            <form:input path="memPhone" cssClass="form-control editable-field"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">부서</label>
                            <input type="text" class="form-control" value="${user.deptName}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">직급</label>
                            <input type="text" class="form-control" value="${user.rankName}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">재직상태</label>
                            <input type="text" class="form-control" value="${user.memStatus}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">입사일</label>
                            <input type="date" class="form-control" value="${user.memHiredate}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-control" value="${user.memEmail}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">2차 이메일</label>
                            <form:input path="privateEmail" type="email" cssClass="form-control editable-field"/>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">주소</label>
                            <form:input path="memAddress" cssClass="form-control editable-field"/>
                        </div>
                    </div>
                </div>
            </div>

            <h5 class="section-title fw-bold mb-3">연차 정보</h5>
            <div class="row mb-3">
                <div class="col-md-4">
                    <div class="semi-box">
                        <strong>연도:</strong> ${user.year}년<br>
                        <strong>총 연차:</strong> ${user.totalDays}일<br>
                        <strong>사용 연차:</strong> ${user.useDays}일<br>
                        <strong>잔여 연차:</strong> ${user.remainDays}일
                    </div>
                </div>
            </div>

            <h6 class="mt-3 fw-bold">연차 사용 내역</h6>
            <div class="semi-box">
                <table class="table table-bordered annual-table mb-0">
                    <thead>
                    <tr>
                        <th>기간</th>
                        <th>결재자</th>
                        <th>휴가 종류</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="his" items="${user.annualHistoryList}">
                        <tr>
                            <td>${his.startDate} ~ ${his.endDate}</td>
                            <td>${his.approvedByName != null ? his.approvedByName : his.approvedBy}</td>
                            <td>${his.leaveName != null ? his.leaveName : his.leaveCode}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty annualHistoryList}">
                        <tr>
                            <td colspan="3" class="text-center">연차 사용 이력이 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="text-end mt-4">
                <button type="button" class="btn btn-warning btn-sm me-2" onclick="getPassEditForm()">비밀번호 변경</button>
                <button type="submit" class="btn btn-primary btn-sm">저장</button>
                <button type="reset" class="btn btn-outline-secondary btn-sm">초기화</button>
            </div>
        </form:form>
    </div>
</div>
</body>
</html>