<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ 수정</title>
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
    <h3 class="fw-bold mb-4">자주 묻는 질문 수정</h3>

    <%--@elvariable id="faqFormDto" type=""--%>
    <form:form action="updateFaqByMng" modelAttribute="faqFormDto"  method="post">
        <spring:hasBindErrors name="faqFormDto">
            <font color="red"> <c:forEach items="${errors.globalErrors}"
                                          var="error">
                <spring:message code="${error.code}" />
                <br>
            </c:forEach>
            </font>
        </spring:hasBindErrors>

        <input type="hidden" name="faqId" value="${faq.faqId}"/>
        <input type="hidden" name="page" value="${faq.page}"/>

        <!-- 질문 -->
        <div class="mb-3">
            <label for="faqTitle" class="form-label">질문</label>
            <input type="text" class="form-control" id="faqTitle" name="faqTitle"  value="${faq.faqTitle}">
            <p style="color: red"><form:errors path="faqTitle"/></p>
        </div>

        <!-- 답변 -->
        <div class="mb-3">
            <label for="faqContent" class="form-label">답변</label>
            <textarea class="form-control" id="faqContent" name="faqContent" rows="6" >${faq.faqContent}</textarea>
            <p style="color: red"><form:errors path="faqContent"/></p>
        </div>

        <!-- 작성 부서 -->
        <div class="mb-4">
            <label for="deptId" class="form-label">작성 부서</label>
            <select class="form-select" id="deptId" name="deptId" >
                <option value="${faq.deptId}">${faq.deptName}</option>
                <c:forEach items="${dept}" var="d">
                    <option value="${d.deptId}">${d.deptName}</option>
                </c:forEach>
            </select>
            <p style="color: red"><form:errors path="deptId"/></p>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">초기화</button>
                <button type="submit" class="btn btn-primary">수정</button>
            </div>
            <div>
                <a onclick="window.close()" class="btn btn-outline-secondary">← 닫기</a>
            </div>
        </div>
    </form:form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
