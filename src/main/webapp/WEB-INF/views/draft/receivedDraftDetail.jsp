<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>받은 전자결재 상세보기 - LDBSOFT</title>

    <style>
        .container {
            max-width: 1000px;
            margin-top: 40px;
        }

        .section-title {
            margin-top: 30px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container  p-4  rounded">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-">받은 전자결재 상세보기</h2>
    </div>

    <%-- 에러 메시지 출력   --%>
    <c:if test="${not empty globalError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i>
                ${globalError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- 문서 기본 정보 -->
    <table class="table table-bordered mt-4 ">
        <tbody>
        <tr>
            <th style="width: 15%;">문서번호</th>
            <td>${draftDetail.docId}</td>
            <th style="width: 15%;">양식</th>
            <td>${draftDetail.formCodeStr}</td>
        </tr>
        <tr>
            <th>제목</th>
            <td colspan="3">${draftDetail.title}</td>
        </tr>
        <tr>
            <th>기안자</th>
            <td>${draftDetail.memName}</td>
            <th>상태</th>
            <td><span id="status-badge"></span></td>
        </tr>
        <tr>
            <th>1차 결재자</th>
            <td>${draftDetail.approver1Name}</td>
            <th>2차 결재자</th>
            <td>${draftDetail.approver2Name}</td>
        </tr>
        <tr>
            <th>문서종료일</th>
            <td colspan="3">${draftDetail.docEndDate}</td>
        </tr>
        </tbody>
    </table>

    <!-- 양식별 상세 -->
    <c:choose>
        <c:when test="${draftDetail.formCode == 'app_01'}">
            <div class="section-title">휴가신청서</div>
            <div class="card   mb-4">
                <div class="card-body">
                    <p><strong>휴가 유형:</strong> ${draftDetail.leaveCode}</p>
                    <p><strong>휴가 기간:</strong> ${draftDetail.leaveStartStr} ~ ${draftDetail.leaveEndStr}</p>
                    <p><strong>총 일수:</strong> ${draftDetail.requestDays}일</p>
                    <p><strong>잔여 연차:</strong> ${remainDays}일</p>
                </div>
            </div>
        </c:when>

        <c:when test="${draftDetail.formCode == 'app_02'}">
            <div class="section-title">프로젝트 제안서</div>
            <div class="card   mb-4">
                <div class="card-body">
                    <p><strong>프로젝트명:</strong> ${draftDetail.projectName}</p>
                    <p><strong>기간:</strong> ${draftDetail.projectStartStr} ~ ${draftDetail.projectEndStr}</p>
                </div>
            </div>
        </c:when>

        <c:when test="${draftDetail.formCode == 'app_03'}">
            <div class="section-title">지출결의서</div>
            <div class="card mb-4">
                <div class="card-body">
                    <p><strong>지출 내역:</strong> ${draftDetail.exName}</p>
                    <p><strong>지출 금액:</strong>
                        <fmt:formatNumber value="${draftDetail.exAmount}" type="currency" currencySymbol="₩"/>원
                    </p>
                    <p><strong>사용일자:</strong> ${draftDetail.useDateStr}</p>
                </div>
            </div>
        </c:when>

        <c:when test="${draftDetail.formCode == 'app_04'}">
            <div class="section-title">사직서</div>
            <div class="card   mb-4">
                <div class="card-body">
                    <p><strong>사직일자:</strong> ${draftDetail.resignDateStr}</p>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="section-title">기타 양식</div>
            <div class="card   mb-4">
                <div class="card-body">
                    <p>해당 양식에 대한 상세 정보가 없습니다.</p>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- 본문 내용 -->
    <div class="section-title text-">본문 내용</div>
    <div class="border p-3 ">
        ${draftDetail.content}
    </div>

    <!-- 첨부파일 -->
    <div class="mb-3">
        <strong>첨부파일:</strong>
        <c:if test="${attachments != null }">
            <c:forEach items="${attachments}" var="a">
                <c:if test="${a.filePath != null}">
                    <div class="file-section mt-2">
                        <a href="${a.filePath}${a.savedName}" download="${a.originalName}"
                           class="link-light ms-2 text-decoration-underline">
                                ${a.originalName}
                        </a>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
    </div>

    <!-- 결재 처리 -->
    <div class="section-title">결재 처리</div>
    <form action="updateDraft" method="post">
        <input type="hidden" name="docId" value="${draftDetail.docId}"/>
        <input type="hidden" name="status" value="${draftDetail.status}"/>
        <input type="hidden" name="formCode" value="${draftDetail.formCode}"/>
        <c:if test="${draftDetail.formCode == 'app_01'}">
            <input type="hidden" name="requestDays" value="${draftDetail.requestDays}"/>
        </c:if>
        <div class="mb-3">
            <label class="form-label">결재 의견 (선택)</label>
            <textarea class="form-control " name="comment" rows="3"
                      placeholder="결재 의견을 입력하세요 (선택 사항)"></textarea>
        </div>

        <c:if test="${(draftDetail.status == 1 && draftDetail.approver1 == sessionScope.loginId)
                    || ((draftDetail.status == 2 || draftDetail.status == 4)
                    && draftDetail.approver2 == sessionScope.loginId)}">
        <div class="d-flex justify-content-end gap-2">
                <button type="submit" name="action" value="approve" class="btn btn-success ">승인</button>
                <button type="submit" name="action" value="reject" class="btn btn-danger ">반려</button>
            </div>
        </c:if>


    </form>

    <div class="d-flex justify-content-between align-items-center mt-4">
        <a href="receivedDraftList" class="btn btn-secondary">← 목록으로</a>
        <button onclick="window.print()" class="btn btn-outline-light ">인쇄</button>
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
