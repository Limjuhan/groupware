<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 800px;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="container bg-white p-5 shadow-sm rounded mt-5 mb-5">
    <h3 class="fw-bold mb-4">자주 묻는 질문 등록</h3>

    <%--@elvariable id="faqFormDto" type=""--%>
    <form:form action="insertFaqByMng" modelAttribute="faqFormDto"  method="post">
        <spring:hasBindErrors name="faqFormDto">
            <font color="red"> <c:forEach items="${errors.globalErrors}"
                                          var="error">
                <spring:message code="${error.code}" />
                <br>
            </c:forEach>
            </font>
        </spring:hasBindErrors>

        <!-- 질문 -->
        <div class="mb-3">
            <label for="faqTitle" class="form-label">질문</label>
            <input type="text" class="form-control" id="faqTitle" name="faqTitle"  placeholder="예: 연차 신청은 어떻게 하나요?">
            <p style="color: red"><form:errors path="faqTitle"/></p>
        </div>

        <!-- 답변 -->
        <div class="mb-3">
            <label for="faqContent" class="form-label">답변</label>
            <textarea class="form-control" id="faqContent" name="faqContent" rows="6"  placeholder="답변을 입력하세요. 예: 인사시스템에서 로그인 후…"></textarea>
            <p style="color: red"><form:errors path="faqContent"/></p>
        </div>

        <!-- 작성 부서 -->
        <div class="mb-4">
            <label for="deptId" class="form-label">작성 부서</label>
            <select class="form-select" id="deptId" name="deptId">
                <option value="">-- 부서 선택 --</option>
                <c:forEach items="${dept}" var="d">
                    <option value="${d.deptId}" >${d.deptName}</option>
                </c:forEach>
            </select>
            <p style="color: red"><form:errors path="deptId"/></p>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a onclick="window.close()" class="btn btn-outline-secondary">← 닫기</a>
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">초기화</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </form:form>
</div>
</body>
</html>
