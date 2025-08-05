<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (필수) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Summernote CSS/JS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>

    <style>
        .form-label {
            font-weight: bold;
        }
        .container {
            max-width: 800px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h3 class="fw-bold mb-4">공지사항 작성</h3>

    <!-- 파일 업로드를 위해 multipart/form-data 필요 -->
    <form:form action="updateNoticeByMng"  modelAttribute="noticeUpdateDto"   method="post" enctype="multipart/form-data">

        <spring:hasBindErrors name="noticeUpdateDto">
            <p color="red"> <c:forEach items="${errors.globalErrors}"
                                          var="error">
                <spring:message code="${error.code}" />
                <br>
            </c:forEach>
            </p>
        </spring:hasBindErrors>
        <!-- 제목 -->
        <div class="mb-3">
            <label for="noticeTitle" class="form-label">제목</label>
            <input type="text" class="form-control" id="noticeTitle" name="noticeTitle"  value="${notice.noticeTitle}">
            <p style="color: red"><form:errors path="noticeTitle"/></p>
        </div>

        <input type="hidden" name="noticeId" value="${notice.noticeId}">
        <!-- 작성자 -->
        <div class="mb-3">
            <label for="memName" class="form-label">작성자</label>
            <input type="text" class="form-control" id="memName"   value="${notice.memName}" readonly >
            <input type="hidden" name="memId" value="${notice.memId}">
        </div>

        <!-- 내용 -->
        <div class="mb-3">
            <label for="noticeContent" class="form-label">내용</label>
            <textarea class="form-control" id="noticeContent" name="noticeContent" rows="8" >${notice.noticeContent}</textarea>
            <p style="color: red"><form:errors path="noticeContent"/></p>
        </div>

        <!-- 상단 고정 여부 -->
        <!-- 기본값: N -->
        <input type="hidden" name="isPinned" value="N" id="isPinnedHidden">

        <!-- 체크 시: Y -->
        <div class="mb-3 form-check">
            <c:choose>
                <c:when test="${notice.isPinned.toString() eq 'Y'}">
                    <input type="checkbox" class="form-check-input" id="isPinned"   onclick="updateIsPinnedHidden(this)" checked>
                </c:when>
                <c:otherwise>
                    <input type="checkbox" class="form-check-input" id="isPinned"   onclick="updateIsPinnedHidden(this)" >
                </c:otherwise>
            </c:choose>


            <label class="form-check-label" for="isPinned">상단 고정</label>
        </div>

        <input  type="hidden" name="noticeCnt" value=0>
        <!-- 첨부파일 -->
        <c:forEach var="file" items="${attachedFiles}">
            <div class="d-flex align-items-center mb-2" id="${file.savedName}">
                <a href="${file.filePath}${file.savedName}" download="${file.originalName}">
                        ${file.originalName}
                </a>
                <button type="button" class="btn btn-sm btn-outline-danger ms-2"
                        onclick="removeFile('${file.savedName}')">삭제</button>
            </div>
        </c:forEach>
        <div id="deleteFile">

        </div>
        <div id="fileInputs">
            <div class="mb-2">
                <input class="form-control" type="file" name="uploadFile" />
            </div>
        </div>
        <button type="button" class="btn btn-outline-secondary" onclick="addFileInput()">+ 파일 추가</button>

        <!-- 버튼 영역 -->
        <div class="d-flex justify-content-between">
            <div>
                <button type="button" onclick="resetForm()" class="btn btn-outline-warning me-2">리셋</button>
                <button type="submit" class="btn btn-primary">등록</button>
            </div>
            <div>
                <a onclick="window.close()" class="btn btn-outline-secondary">← 닫기</a>
            </div>
        </div>
    </form:form>
</div>
<script>
    function resetForm() {
        // 1. 일반 form reset
        document.querySelector("form").reset();
        // 2. summernote 내용 초기화
        $('#noticeContent').summernote('reset'); // 또는 .code('')
    }

    function removeFile(f){
        if(confirm("삭제할건가요??")) {
            document.getElementById(f).remove();
            let container = document.getElementById("deleteFile");
            let newInput = document.createElement("div");
            newInput.innerHTML = '<input type="hidden" name="existingFiles" value="' + f + '"/>';
            container.appendChild(newInput);

        }
    }

    function addFileInput() {
        const container = document.getElementById("fileInputs");
        const newInput = document.createElement("div");
        newInput.className = "mb-2";
        newInput.innerHTML = '<input class="form-control" type="file" name="uploadFile" />';
        container.appendChild(newInput);
    }

    function updateIsPinnedHidden(checkbox) {
        const hidden = document.getElementById('isPinnedHidden');
        hidden.value = checkbox.checked ? 'Y' : 'N'; //체크박스가 선택됐다면 Y로바꿔
    }

    $(document).ready(function () {
        $('#noticeContent').summernote({
            height: 300,
            placeholder: '공지 내용을 입력하세요',
            lang: 'ko-KR'
        });
    });

    function addFileInput() {
        const container = document.getElementById("fileInputs");
        const newInput = document.createElement("div");
        newInput.className = "mb-2";
        newInput.innerHTML = '<input class="form-control" type="file" name="uploadFile" />'; //동적으로 사진을 넣음
        container.appendChild(newInput);
    }

    //체크박스가선택되면 isPinned를 Y로 바꾸기위함
    function updateIsPinnedHidden(checkbox) {
        const hidden = document.getElementById('isPinnedHidden');
        hidden.value = checkbox.checked ? 'Y' : 'N';
    }


</script>

</body>
</html>
