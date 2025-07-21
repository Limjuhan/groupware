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
            background: rgba(255, 255, 255, 0.1); /* 반투명 */
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
        }
    </style>
</head>
<body>
<div class="form-section">
    <h3 class="mb-4 fw-bold">사원등록</h3>
    <form action="insertMemberByMng" method="post" >
        <div class="row">
            <div class="col-md-9">
                <div class="row">
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
                        <label class="form-label">2차 이메일 (개인 이메일)</label>
                        <input type="email" name="memPrivateEmail" class="form-control"
                               placeholder="example@gmail.com"/>
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
            <div class="col-md-3 text-center">
                <div class="photo-preview">사진<br>없음</div>
                <input type="file" name="photo" class="form-control form-control-sm"/>
            </div>
        </div>
        <div class="text-end mt-4">
            <button type="submit" class="btn btn-primary">저장</button>
            <button type="reset" class="btn btn-secondary">취소</button>
            <a href="/admin/getMemberList" class="btn btn-outline-light">목록</a>
        </div>
    </form>
</div>
</body>
</html>
