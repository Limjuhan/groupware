<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>사원 등록</title>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .form-section {
            max-width: 900px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            color: white;
        }

        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.15) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .form-select option {
            background-color: #343a40;
            color: white;
        }

        .form-label {
            font-weight: bold;
            color: white;
        }

        .photo-preview {
            width: 150px;
            height: 150px;
            background-color: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 5px;
            font-size: 12px;
            color: white;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            object-fit: cover;
        }
    </style>
</head>
<body>
<div class="form-section">
    <h3 class="mb-4 fw-bold">사원등록</h3>
    <form action="insertMemberByMng" method="post" enctype="multipart/form-data">
        <div class="row">
            <div class="col-md-3 text-center">
                <img id="preview" src="/img/profile_default.png" alt="사진 미리보기" class="photo-preview" />
                <input type="file" name="uploadFile" class="form-control form-control-sm" onchange="previewPhoto(event)" accept="image/*" />
            </div>
            <div class="col-md-9">
                <div class="row">
                    <!-- 기존 폼 내용 그대로 유지 -->
                    <div class="col-md-6 mb-3">
                        <label class="form-label">이름 *</label>
                        <input type="text" name="memName" class="form-control" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">성별</label>
                        <select name="memGender" class="form-select">
                            <option value="">성별 선택</option>
                            <option value="남">남</option>
                            <option value="여">여</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">전화번호 *</label>
                        <input type="text" name="memPhone" class="form-control" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">2차 이메일</label>
                        <input type="email" name="memPrivateEmail" class="form-control" placeholder="example@gmail.com"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">주민번호 앞자리 *</label>
                        <input type="text" name="juminFront" maxlength="6" class="form-control" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">주민번호 뒷자리 *</label>
                        <input type="password" name="juminBack" maxlength="7" class="form-control" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">부서 *</label>
                        <select name="deptId" class="form-select" required>
                            <option value="">부서 선택</option>
                            <c:forEach var="dept" items="${deptList}">
                                <option value="${dept.deptId}">${dept.deptName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">직급 *</label>
                        <select name="rankId" class="form-select" required>
                            <option value="">직급 선택</option>
                            <c:forEach var="rank" items="${rankList}">
                                <option value="${rank.rankId}">${rank.rankName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">입사일 *</label>
                        <input type="date" name="memHiredate" class="form-control" required/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">재직상태 *</label>
                        <select name="memStatus" class="form-select" required>
                            <option value="">상태 선택</option>
                            <option value="재직">재직</option>
                            <option value="퇴직">퇴직</option>
                        </select>
                    </div>
                    <div class="col-md-12 mb-3">
                        <label class="form-label">주소</label>
                        <input type="text" name="memAddress" class="form-control"/>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-end mt-4">
            <a href="/admin/memberList" class="btn btn-secondary">목록</a>
            <button type="submit" class="btn btn-primary">저장</button>
            <button type="reset" class="btn btn-outline-light">입력 초기화</button>
        </div>
    </form>
</div>

<!-- ✅ 미리보기 스크립트 -->
<script type="text/javascript">
    function previewPhoto(event) {
        const file = event.target.files[0];
        const preview = document.getElementById("preview");
        if (file) {
            if (!file.type.startsWith("image/")) {
                alert("이미지 파일만 업로드 가능합니다.");
                event.target.value = ""; // 파일 선택 초기화
                preview.src = "/img/profile_default.png";
                return;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = "/img/profile_default.png"; // 기본 이미지
        }
    }
</script>
</body>
</html>