<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 등록 - LDBSOFT</title>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .container {
            max-width: 1200px;
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

        .btn {
            border-radius: 0.375rem;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 0.375rem;
            border: 1px solid #dee2e6;
        }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card p-4">
        <h3 class="mb-4 fw-bold">사원 등록</h3>
        <form:form modelAttribute="memberFormDto" method="post" action="insertMemberByMng"
                   enctype="multipart/form-data">
            <div class="row">
                <div class="col-md-3 text-center">
                    <img id="preview" src="/img/profile_default.png" alt="사진 미리보기" class="photo-preview mb-2"/>
                    <form:input path="photo" type="file" class="form-control form-control-sm mt-2"
                                onchange="previewPhoto(event)" accept="image/*"/>
                </div>
                <div class="col-md-9">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">이름</label>
                            <form:input path="memName" class="form-control"/>
                            <form:errors path="memName" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">성별</label>
                            <form:select path="memGender" class="form-select">
                                <form:option value="">성별 선택</form:option>
                                <form:option value="남">남</form:option>
                                <form:option value="여">여</form:option>
                            </form:select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">전화번호</label>
                            <form:input path="memPhone" class="form-control"/>
                            <form:errors path="memPhone" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">2차 이메일</label>
                            <form:input path="memPrivateEmail" type="email" class="form-control"/>
                            <form:errors path="memPrivateEmail" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">주민번호 앞자리</label>
                            <form:input path="juminFront" class="form-control" maxlength="6"/>
                            <form:errors path="juminFront" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">주민번호 뒷자리</label>
                            <form:password path="juminBack" class="form-control" maxlength="7"/>
                            <form:errors path="juminBack" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">부서</label>
                            <form:select path="deptId" class="form-select">
                                <form:option value="">부서 선택</form:option>
                                <c:forEach var="dept" items="${deptList}">
                                    <form:option value="${dept.deptId}">${dept.deptName}</form:option>
                                </c:forEach>
                            </form:select>
                            <form:errors path="deptId" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">직급</label>
                            <form:select path="rankId" class="form-select">
                                <form:option value="">직급 선택</form:option>
                                <c:forEach var="rank" items="${rankList}">
                                    <form:option value="${rank.rankId}">${rank.rankName}</form:option>
                                </c:forEach>
                            </form:select>
                            <form:errors path="rankId" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">입사일</label>
                            <form:input path="memHiredate" type="date" class="form-control"/>
                            <form:errors path="memHiredate" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">재직상태</label>
                            <form:select path="memStatus" class="form-select">
                                <form:option value="">상태 선택</form:option>
                                <form:option value="재직">재직</form:option>
                                <form:option value="퇴직">퇴직</form:option>
                            </form:select>
                            <form:errors path="memStatus" cssClass="text-danger"/>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label">주소</label>
                            <form:input path="memAddress" class="form-control"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-end mt-4">
                <a href="/admin/getMemberList" class="btn btn-outline-secondary">목록</a>
                <button type="submit" class="btn btn-primary">저장</button>
                <button type="reset" class="btn btn-outline-secondary">초기화</button>
            </div>
        </form:form>
    </div>
</div>
<script type="text/javascript">
    function previewPhoto(event) {
        const file = event.target.files[0];
        const preview = document.getElementById("preview");
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = "/img/profile_default.png";
        }
    }
</script>
</body>
</html>