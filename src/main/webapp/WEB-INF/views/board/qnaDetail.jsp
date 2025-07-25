<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 860px;
        }
        .question-box {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .question-title {
            font-size: 1.6rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .question-meta {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 1.5rem;
        }
        .question-content {
            font-size: 1rem;
            line-height: 1.7;
            white-space: pre-wrap;
            color: #212529;
        }
        .btn-group {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        .file-section {
            margin-top: 30px;
            background-color: #f8f9fb;
            border-left: 4px solid #0d6efd;
            padding: 15px 20px;
            border-radius: 6px;
        }

        .file-section a {
            font-weight: 500;
            text-decoration: none;
            color: #0d6efd;
        }

        .comment-box {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 30px;
        }
        .comment-item {
            border-bottom: 1px solid #eee;
            padding: 12px 0;
        }
        .comment-meta {
            font-size: 0.85rem;
            color: #6c757d;
        }
    </style>
</head>
<body>

<div class="container mt-5">

    <!-- 질문 박스 -->
    <div class="question-box">
        <div class="question-title">${q.qnaTitle}</div>
        <div class="question-meta">작성자: ${q.memName} | 작성일: ${q.createFormat} | 수정일 : ${q.updateFormat}</div>
        <div class="question-content">${q.qnaContent}</div>
        <c:if test="${attach != null }">
            <c:forEach items="${attach}" var="a">
                <c:if test="${a.filePath != null}">
                    <div class="file-section mt-4">
                        첨부파일:
                        <a href="${a.filePath}${a.savedName}" download="${a.originalName}">${a.originalName}</a>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
        <!-- 수정/삭제 버튼 -->
        <div class="btn-group">
            <a href="getQnaList" class="btn btn-outline-secondary">← 목록으로</a>
            <div>
                <a onclick="goForm('getQnaEditForm?id=${q.qnaId}')" class="btn btn-outline-primary me-2">수정</a>
                <a href="deleteQnaByMng?id=${q.qnaId}" class="btn btn-outline-danger"
                   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
            </div>

        </div>

    </div>


    <!-- 댓글 영역 -->
    <div class="comment-box">
        <h5 class="mb-3">댓글 <span class="text-muted"></span></h5>
        <div id="commentList">
       <%-- ajax이용호출 --%>
        </div>
    </div>


        <!-- 댓글 작성 폼 -->
        <form:form  id="commentForm" class="mt-4" >
            <input type="hidden" name="qnaId" id="qnaId" value="${q.qnaId}">
            <input type="hidden" name="memId" id="memId" value=${loginId}> <%--나중에세션으로?--%>
            <div class="mb-3">
                <textarea name="commentText"  id="commentText" class="form-control" rows="3"  placeholder="댓글을 입력하세요." onkeyup="delError(this)"></textarea>
                <p style="color: red" id="commentTextError"></p>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-sm btn-primary">댓글 등록</button>
            </div>
        </form:form>
    </div>

</div>
<script>

    function goForm(url){
        let op = "width=500,height=700,top=50,left=150";
        window.open(url, "", op);
    }

    function delError(f){
        $('#commentTextError').html('');
    }
    $(document).ready(function () {
        loadComments($('#qnaId').val());
    });

    function loadComments(qnaId) {
        $.ajax({
            url: '/api/qna/comments',
            type: 'GET',
            data: { qnaId: qnaId },
            success: function (comments) {
                console.log(comments);
                let html = '';
                comments.forEach(function(c) {
                    html += '<div class="comment-item position-relative">';
                    html +=   '<a href="deleteCommentByMng?id=' + c.commentId +"&qnaId="+ qnaId+'" class="btn btn-sm btn-outline-danger position-absolute top-0 end-0" style="margin: 5px;" onclick="return confirm(\'정말 삭제하시겠습니까?\');">삭제</a>';
                    html +=   '<div><strong>' + c.memName + '</strong></div>';
                    html +=   '<div class="mb-1">' + c.commentText + '</div>';
                    html +=   '<div class="comment-meta">' + c.createdAt + '</div>';
                    html += '</div>';
                });
                $('#commentList').html(html); // 새로운 댓글 삽입
            },
            error: function () {
                alert('댓글 불러오기 실패');
            }
        });
    }

    $('#commentForm').on('submit', function (e) {
        e.preventDefault(); //기본 동작(예: form submit 후 새로고침)을 막는다
         let commentFormDto = JSON.stringify({
            qnaId: $('#qnaId').val(),
            memId: $('#memId').val(),
            commentText: $('#commentText').val()
        })
        $.ajax({
            url:"/api/qna/insertComment",
            type: "POST",
            data: commentFormDto, //JSON객체로변환
            contentType: 'application/json', //JSON타입임을 명시

            success: function (response) {
                loadComments($('#qnaId').val());
                    $('#commentText').val('');
            },
            error: function (xhr) {
                if (xhr.status === 400 && xhr.responseJSON && xhr.responseJSON.data) {
                    let error = xhr.responseJSON.data;
                    console.log(error);
                    $('#commentTextError').html(error.commentText);
                } else {
                    alert('수정 실패: ' + (xhr.responseJSON ? xhr.responseJSON.error : "서버 오류"));
                }
            }


        })

    })
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
