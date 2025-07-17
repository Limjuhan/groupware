<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .notice-table th, .notice-table td {
            vertical-align: middle;
            text-align: center;
        }
        .fixed-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .notice-title {
            text-align: left;
            padding-left: 1rem;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <!-- 제목 + 등록 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">공지사항</h3>
        <a href="noticeWrite.jsp" class="btn btn-primary">공지 등록</a>
    </div>

    <!-- 검색 폼 -->
    <form action="board/noticeList" method="get" class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="title">제목</option>
                <option value="writer">작성자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <!-- 공지 테이블 -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover notice-table">
            <thead class="table-light">
                <tr>
                    <th style="width: 10%;">공지번호</th>
                    <th style="width: 40%;">제목</th>
                    <th style="width: 15%;">작성자</th>
                    <th style="width: 15%;">작성일</th>
                    <th style="width: 10%;">조회수</th>
                </tr>
            </thead>
            <tbody>
                <!-- 상단 고정 공지 -->
                <tr class="fixed-row">
                    <td><i class="bi bi-pin-angle-fill text-danger"></i> 101</td>
                    <td class="notice-title">
                        <a href="board/noticeDetail?id=101" class="text-decoration-none text-dark">
                            [중요] 서버 점검 안내 (7/15)
                        </a>
                    </td>
                    <td>관리자</td>
                    <td>2025-07-08</td>
                    <td>123</td>
                </tr>
                <tr class="fixed-row">
                    <td><i class="bi bi-pin-angle-fill text-danger"></i> 100</td>
                    <td class="notice-title">
                        <a href="noticeDetail?id=100" class="text-decoration-none text-dark">
                            [공지] 그룹웨어 기능 개선 안내
                        </a>
                    </td>
                    <td>관리자</td>
                    <td>2025-07-07</td>
                    <td>89</td>
                </tr>

                <!-- 일반 공지 -->
                <tr>
                    <td>99</td>
                    <td class="notice-title">
                        <a href="noticeDetail?id=99" class="text-decoration-none">
                            7월 신규 입사자 공지
                        </a>
                    </td>
                    <td>인사팀</td>
                    <td>2025-07-06</td>
                    <td>55</td>
                </tr>
                <tr>
                    <td>98</td>
                    <td class="notice-title">
                        <a href="noticeDetail?id=98" class="text-decoration-none">
                            사내 보안 캠페인 안내
                        </a>
                    </td>
                    <td>보안팀</td>
                    <td>2025-07-05</td>
                    <td>47</td>
                </tr>
                <tr>
                    <td>97</td>
                    <td class="notice-title">
                        <a href="noticeDetail.jsp?id=97" class="text-decoration-none">
                            사무실 냉방 관련 협조 요청
                        </a>
                    </td>
                    <td>총무팀</td>
                    <td>2025-07-04</td>
                    <td>61</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 페이징 UI -->
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">다음</a></li>
        </ul>
    </nav>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
