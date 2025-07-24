<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>전자결재 상세보기 - LDBSOFT</title>


    <style>
        body {
            color: white;
        }

        .container {
            max-width: 1000px;
            margin-top: 40px;
        }

        .section-title {
            margin-top: 30px;
            font-weight: bold;
        }

        .table.bg-glass td,
        .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        .text-shadow {
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-shadow">전자결재 상세보기</h2>
        <a href="draftList" class="btn btn-sm btn-secondary bg-glass">← 목록으로</a>
    </div>

    <table class="table table-bordered mt-4 bg-glass">
        <tbody>
        <tr>
            <th style="width: 15%;">문서번호</th>
            <td>${draftDetail.docId}</td>
            <th style="width: 15%;">양식</th>
            <td>${draftDetail.formCode}</td>
        </tr>
        <tr>
            <th>제목</th>
            <td colspan="3">${draftDetail.docTitle}</td>
        </tr>
        <tr>
            <th>기안자</th>
            <td>${draftDetail.memName}</td>
            <th>상태</th>
            <td>
                <span id="status-badge"></span>
            </td>
        </tr>
        <tr>
            <th>1차 결재자</th>
            <td>
                ${draftDetail.approver1Name}
            </td>
            <th>2차 결재자</th>
            <td>
                ${draftDetail.approver2Name}
            </td>
        </tr>
        <tr>
            <th>문서종료일</th>
            <td colspan="3">${draftDetail.docEndDate}</td>
        </tr>
        </tbody>
    </table>

    <!-- 첨부파일 -->
    <div class="mb-3">
        <strong>첨부파일:</strong>
        <c:if test="${attachments != null }">
            <c:forEach items="${attachments}" var="a">
                <c:if test="${a.filePath != null}">
                    <div class="file-section mt-4">
                        첨부파일:
                        <a href="${a.filePath}${a.savedName}" download="${a.originalName}"
                           class="link-light ms-2 text-decoration-underline">
                                ${a.originalName}
                        </a>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
    </div>

    <!-- 본문 내용 -->
    <div class="section-title text-shadow">본문 내용</div>
    <div class="border p-3 bg-glass">
        ${draftDetail.docContent}
    </div>

    <!-- 양식 정보 -->
    <div class="section-title text-shadow">양식 정보</div>
    <table class="table table-bordered bg-glass">
        <tr>
            <th>휴가 유형</th><td>${formDetail.leaveType}</td>
        </tr>
        <tr>
            <th>휴가 기간</th><td>${formDetail.startDate} ~ ${formDetail.endDate}</td>
        </tr>
        <tr>
            <th>잔여 연차</th><td>${formDetail.remainDays}일</td>
        </tr>
    </table>

    <!-- 인쇄 -->
    <div class="text-end">
        <button onclick="window.print()" class="btn btn-outline-light bg-glass">인쇄</button>
    </div>
</div>

<script>

    $(document).ready(function () {
        var status = "${draftDetail.status}";
        var badgeHtml = getStatusBadge(status);
        $("#status-badge").html(badgeHtml);

    });

    function getStatusBadge(status) {
        switch (status) {
            case "0":
                return "<span class='badge bg-secondary'>임시저장</span>";
            case "1":
                return "<span class='badge bg-warning text-dark'>1차결재 대기</span>";
            case "2":
                return "<span class='badge bg-warning text-dark'>1차결재 승인</span>";
            case "3":
                return "<span class='badge bg-danger'>1차결재 반려</span>";
            case "4":
                return "<span class='badge bg-info text-dark'>2차결재 대기</span>";
            case "5":
                return "<span class='badge bg-success'>2차결재 승인</span>";
            case "6":
                return "<span class='badge bg-danger'>2차결재 반려</span>";
            default:
                return "<span class='badge bg-dark'>알 수 없음</span>";
        }
    }
</script>
</body>
</html>
