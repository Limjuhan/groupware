<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 등록 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #1e1e1e;
            color: white;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        .form-section.bg-glass {
            max-width: 900px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 0.5rem;
            padding: 30px;
        }

        .form-control.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .form-control.bg-glass:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: none;
        }

        .form-select.bg-glass {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .form-select.bg-glass:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: none;
        }

        .form-select.bg-glass option {
            background-color: #ffffff;
            color: #000000;
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: "▼";
            position: absolute;
            top: 65%;
            right: 1.0rem;
            transform: translateY(-40%);
            pointer-events: none;
            color: white;
            font-size: 1.2rem;
        }

        .form-label {
            font-weight: bold;
            color: white;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .btn.bg-glass {
            background: rgba(255, 255, 255, 0.1) !important;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
        }

        .btn.bg-glass:hover {
            background: rgba(255, 255, 255, 0.2) !important;
        }

        .text-danger {
            color: #ff6b6b;
            font-size: 0.85rem;
        }

        h3 {
            /* text-shadow 제거 */
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="form-section bg-glass">
    <h3 class="mb-4 fw-bold">👤 사원등록</h3>
    <form:form modelAttribute="memberFormDto" method="post" action="insertMemberByMng" enctype="multipart/form-data">
        <div class="row">
            <div class="col-md-3 text-center">
                <img id="preview" src="/img/profile_default.png" alt="사진 미리보기" class="photo-preview" />
                <form:input path="photo" type="file" class="form-control bg-glass form-control-sm mt-2" onchange="previewPhoto(event)" accept="image/*" />
            </div>
            <div class="col-md-9">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">이름 *</label>
                        <form:input path="memName" class="form-control bg-glass" />
                        <form:errors path="memName" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3 select-wrapper">
                        <label class="form-label">성별</label>
                        <form:select path="memGender" class="form-select bg-glass custom-select-arrow">
                            <form:option value="">성별 선택</form:option>
                            <form:option value="남">남</form:option>
                            <form:option value="여">여</form:option>
                        </form:select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">전화번호 *</label>
                        <form:input path="memPhone" class="form-control bg-glass" />
                        <form:errors path="memPhone" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">2차 이메일</label>
                        <form:input path="memPrivateEmail" type="email" class="form-control bg-glass" />
                        <form:errors path="memPrivateEmail" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">주민번호 앞자리 *</label>
                        <form:input path="juminFront" class="form-control bg-glass" maxlength="6" />
                        <form:errors path="juminFront" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">주민번호 뒷자리 *</label>
                        <form:password path="juminBack" class="form-control bg-glass" maxlength="7" />
                        <form:errors path="juminBack" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3 select-wrapper">
                        <label class="form-label">부서 *</label>
                        <form:select path="deptId" class="form-select bg-glass custom-select-arrow">
                            <form:option value="">부서 선택</form:option>
                            <c:forEach var="dept" items="${deptList}">
                                <form:option value="${dept.deptId}">${dept.deptName}</form:option>
                            </c:forEach>
                        </form:select>
                        <form:errors path="deptId" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3 select-wrapper">
                        <label class="form-label">직급 *</label>
                        <form:select path="rankId" class="form-select bg-glass custom-select-arrow">
                            <form:option value="">직급 선택</form:option>
                            <c:forEach var="rank" items="${rankList}">
                                <form:option value="${rank.rankId}">${rank.rankName}</form:option>
                            </c:forEach>
                        </form:select>
                        <form:errors path="rankId" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">입사일 *</label>
                        <form:input path="memHiredate" type="date" class="form-control bg-glass" />
                        <form:errors path="memHiredate" cssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3 select-wrapper">
                        <label class="form-label">재직상태 *</label>
                        <form:select path="memStatus" class="form-select bg-glass custom-select-arrow">
                            <form:option value="">상태 선택</form:option>
                            <form:option value="재직">재직</form:option>
                            <form:option value="퇴직">퇴직</form:option>
                        </form:select>
                        <form:errors path="memStatus" cssClass="text-danger" />
                    </div>
                    <div class="col-md-12 mb-3">
                        <label class="form-label">주소</label>
                        <form:input path="memAddress" class="form-control bg-glass" />
                    </div>
                </div>
            </div>
        </div>
        <div class="text-end mt-4">
            <a href="/admin/getMemberList" class="btn bg-glass">목록</a>
            <button type="submit" class="btn btn-primary bg-glass">저장</button>
            <button type="reset" class="btn btn-secondary bg-glass">입력 초기화</button>
        </div>
    </form:form>
</div>
<script type="text/javascript">
    function previewPhoto(event) {
        const file = event.target.files[0];
        const preview = document.getElementById("preview");
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
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