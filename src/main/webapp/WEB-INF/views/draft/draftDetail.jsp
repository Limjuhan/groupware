<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

        /* 테이블 셀에 bg-glass 효과 */
        .table.bg-glass td,
        .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        /* 텍스트 그림자: 어두운 배경 위에서 강조 */
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

    <!-- 문서 요약 -->
    <table class="table table-bordered mt-4 bg-glass">
        <tbody>
        <tr>
            <th style="width: 15%;">문서번호</th><td>A00001</td>
            <th style="width: 15%;">양식</th><td>휴가신청서</td>
        </tr>
        <tr>
            <th>제목</th><td colspan="3">연차 신청 (5/1~5/3)</td>
        </tr>
        <tr>
            <th>기안자</th><td>동곤</td>
            <th>상태</th><td><span class="badge bg-warning text-dark">1차결재 대기</span></td>
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
            <th>문서종료일</th><td colspan="3">2025-05-01</td>
        </tr>
        </tbody>
    </table>

    <!-- 첨부파일 -->
    <div class="mb-3">
        <strong>첨부파일:</strong>
        <a href="download.jsp?file=휴가신청서.pdf" class="link-light ms-2 text-decoration-underline">휴가신청서.pdf</a>
    </div>

    <!-- 본문 내용 -->
    <div class="section-title text-shadow">본문 내용</div>
    <div class="border p-3 bg-glass">
        5월 1일부터 5월 3일까지 개인 연차를 사용하고자 합니다.<br>
        휴가 기간 동안 업무 인계는 완료하였습니다.
    </div>

    <!-- 양식 항목 표시 -->
    <div class="section-title text-shadow">양식 정보</div>
    <table class="table table-bordered bg-glass">
        <tr>
            <th>휴가 유형</th><td>연차</td>
        </tr>
        <tr>
            <th>휴가 기간</th><td>2025-05-01 ~ 2025-05-03</td>
        </tr>
        <tr>
            <th>잔여 연차</th><td>9일</td>
        </tr>
    </table>

    <!-- 인쇄 버튼 -->
    <div class="text-end">
        <button onclick="window.print()" class="btn btn-outline-light bg-glass">인쇄</button>
    </div>
</div>

</body>
</html>
