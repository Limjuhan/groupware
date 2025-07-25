<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (필수) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Summernote CSS/JS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <style>
        body {
            background-color: #f6f8fa;
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
<div class="container mt-5 mb-5 bg-white p-5 shadow-sm rounded">
    <h3 class="fw-bold mb-4">질문 작성</h3>

    <form:form action="insertQna" method="post" modelAttribute="qnaFormDto" enctype="multipart/form-data">

    <!-- 작성자 (자동 입력) -->
        <div class="mb-4">
            <label for="v" class="form-label">작성자</label>
            <input type="text" class="form-control" id="memName" name="memName" value="${memName}" readonly>
            <input type="hidden" name="memId" value="${loginUser}">
        </div>
        <!-- 제목 -->
        <div class="mb-3">
            <label for="qnaTitle" class="form-label">질문 제목</label>
            <input type="text" class="form-control" id="qnaTitle" name="qnaTitle"  placeholder="예: 연차 신청은 어떻게 하나요?">
            <p style="color: red"><form:errors path="qnaTitle"/></p>
        </div>

        <!-- 내용 -->
        <div class="mb-3">
            <label for="qnaContent" class="form-label">질문 내용</label>
            <textarea class="form-control" id="qnaContent" name="qnaContent" rows="7"  placeholder="질문의 상세 내용을 입력해 주세요."></textarea>
            <p style="color: red"><form:errors path="qnaContent"/></p>
        </div>
        <!-- 첨부파일 -->
        <div id="fileInputs">
            <div class="mb-2">
                <input class="form-control" type="file" name="uploadFile" />
            </div>
        </div>

        <button type="button" class="btn btn-outline-secondary" onclick="addFileInput()">+ 파일 추가</button>
        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
            <a onclick="window.close()" class="btn btn-outline-secondary">x 닫기</a>
            <div>
                <button type="reset" class="btn btn-outline-warning me-2">초기화</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
        </div>
    </form:form>
</div>
<script>
    function resetForm() {
        // 1. 일반 form reset
        document.querySelector("form").reset();

        // 2. summernote 내용 초기화
        $('#qnaContent').summernote('reset'); // 또는 .code('')
    }

    function addFileInput() {
        const container = document.getElementById("fileInputs");
        const newInput = document.createElement("div");
        newInput.className = "mb-2";
        newInput.innerHTML = '<input class="form-control" type="file" name="uploadFile" />';
        container.appendChild(newInput);
    }

    $(document).ready(function() { /*summerNote*/
        $('#qnaContent').summernote({
            height: 300,
            placeholder: '공지 내용을 입력하세요',
            lang: 'ko-KR'
        });
    });

    function addFileInput() {
        const container = document.getElementById("fileInputs");
        const newInput = document.createElement("div");
        newInput.className = "mb-2";
        newInput.innerHTML = '<input class="form-control" type="file" name="uploadFile" />'; //동적으로 파일추가를
        container.appendChild(newInput);
    }



</script>
</body>
</html>
