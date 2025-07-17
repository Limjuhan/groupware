<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>받은 전자결재 상세보기 - LDBSOFT</title>
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

        .table.bg-glass td, .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        a.link-white {
            color: #cfe2ff;
            text-decoration: underline;
        }

        a.link-white:hover {
            color: #ffffff;
        }
    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <div class="d-flex justify-content-between">
        <h2>전자결재 상세보기</h2>
        <a href="receivedDraftList" class="btn btn-sm btn-secondary bg-glass">← 목록으로</a>
    </div>

    <!-- 문서 요약 -->
    <table class="table table-bordered mt-4 bg-glass">
        <tbody>
        <tr>
            <th style="width: 15%;">문서번호</th>
            <td>A00001</td>
            <th style="width: 15%;">양식</th>
            <td>휴가신청서</td>
        </tr>
        <tr>
            <th>제목</th>
            <td colspan="3">연차 신청 (5/1~5/3)</td>
        </tr>
        <tr>
            <th>기안자</th>
            <td>동곤</td>
            <th>상태</th>
            <td><span class="badge bg-warning text-dark">1차결재 대기</span></td>
        </tr>
        <tr>
            <th>1차 결재자</th>
            <td>
                김이사
                <span class="badge bg-warning text-dark ms-2">대기</span>
            </td>
            <th>2차 결재자</th>
            <td>
                박부장
                <span class="badge bg-secondary ms-2">미진행</span>
            </td>
        </tr>
        <tr>
            <th>마감기한</th>
            <td colspan="3">2025-05-01</td>
        </tr>
        </tbody>
    </table>

    <!-- 첨부파일 -->
    <div class="mb-3">
        <strong>첨부파일:</strong>
        <a href="download.jsp?file=휴가신청서.pdf" class="link-white ms-2">휴가신청서.pdf</a>
    </div>

    <!-- 본문 내용 -->
    <div class="section-title">본문 내용</div>
    <div class="border p-3 bg-glass">
        5월 1일부터 5월 3일까지 개인 연차를 사용하고자 합니다.<br>
        휴가 기간 동안 업무 인계는 완료하였습니다.
    </div>

    <!-- 양식 항목 표시 -->
    <div class="section-title">양식 정보</div>
    <table class="table table-bordered bg-glass">
        <tr>
            <th>휴가 유형</th>
            <td>연차</td>
        </tr>
        <tr>
            <th>휴가 기간</th>
            <td>2025-05-01 ~ 2025-05-03</td>
        </tr>
        <tr>
            <th>잔여 연차</th>
            <td>9일</td>
        </tr>
    </table>

    <div class="section-title">결재 처리</div>

    <form action="approvalAction.jsp" method="post">
        <input type="hidden" name="docId" value="A00001"/>

        <div class="mb-3">
            <label class="form-label">결재 의견 (선택)</label>
            <textarea class="form-control bg-glass" name="comment" rows="3" placeholder="결재 의견을 입력하세요 (선택 사항)"></textarea>
        </div>

        <div class="d-flex justify-content-start gap-2">
            <button type="submit" name="action" value="approve" class="btn btn-success bg-glass">승인</button>
            <button type="submit" name="action" value="reject" class="btn btn-danger bg-glass">반려</button>
        </div>
    </form>
</div>

</body>
</html>
