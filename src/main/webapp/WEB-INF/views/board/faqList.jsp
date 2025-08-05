<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자주 묻는 질문 (FAQ)</title>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            max-width: 960px;
        }

        .faq-question {
            font-weight: 600;
            color: #0d6efd;
        }

        .faq-answer {
            white-space: pre-wrap;
        }

        .accordion-button {
            font-weight: 600;
        }

        .page-link {
            cursor: pointer;
        }
    </style>
    <script>
        // FAQ 목록을 불러오는 함수
        function loadFaqs(page) {
            if (!page) page = 1;
            const searchType = $('#searchType').val(); // 검색 기준
            const keyword = $('#keyword').val(); // 검색어

            $.ajax({
                url: '/api/faq/faqList',
                type: 'GET',
                data: {
                    page: page,
                    searchType: searchType,
                    keyword: keyword
                },
                dataType: 'json',
                success: function (response) {
                    const faqList = response.data.faqList; // FAQ 목록
                    const pagination = response.data.pageDto; // 페이징 정보
                    const $accordion = $('#faqAccordion').empty(); // 아코디언 영역 초기화

                    if (faqList && faqList.length > 0) {
                        $.each(faqList, function (index, faq) {
                            let item = '<div class="accordion-item mb-2">';
                            item += '<h2 class="accordion-header" id="heading' + faq.faqId + '">';
                            item += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"';
                            item += 'data-bs-target="#collapse' + faq.faqId + '" aria-expanded="false" aria-controls="collapse' + faq.faqId + '">';
                            item += '' + faq.faqTitle;
                            item += '</button>';
                            item += '</h2>';
                            item += '<div id="collapse' + faq.faqId + '" class="accordion-collapse collapse" aria-labelledby="heading' + faq.faqId + '" data-bs-parent="#faqAccordion">';
                            item += '<div class="accordion-body">';
                            item += '<div class="faq-answer mb-2">' + faq.faqContent + '</div>';
                            item += '<div class="text-muted small">작성 부서: ' + faq.deptName + '</div>';
                            item += '</div>';
                            item += '</div>';
                            item += '</div>';
                            $accordion.append(item);
                        });
                    } else {
                        $accordion.append('<p class="text-muted">검색 결과가 없습니다.</p>');
                    }

                    renderPagination(pagination);
                },
                error: function () {
                    alert('FAQ 데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        // 페이징을 렌더링하는 함수
        function renderPagination(pagination) {
            const $paginationArea = $('#paginationArea').empty();
            if (!pagination) return;

            let html = '<ul class="pagination justify-content-center">';
            const currentPage = pagination.page;
            const startPage = pagination.startPage;
            const endPage = pagination.endPage;
            const totalPages = pagination.totalPages;

            // 이전 페이지 버튼
            if (currentPage > 1) {
                html += '<li class="page-item"><a class="page-link" onclick="loadFaqs(' + (currentPage - 1) + ');">이전</a></li>';
            }

            // 페이지 번호 버튼
            for (let i = startPage; i <= endPage; i++) {
                let activeClass = '';
                if (currentPage === i) {
                    activeClass = ' active';
                }
                html += '<li class="page-item' + activeClass + '">' +
                    '<a class="page-link" onclick="loadFaqs(' + i + ');">' + i + '</a>' +
                    '</li>';
            }

            // 다음 페이지 버튼
            if (currentPage < totalPages) {
                html += '<li class="page-item"><a class="page-link" onclick="loadFaqs(' + (currentPage + 1) + ');">다음</a></li>';
            }

            html += '</ul>';
            $paginationArea.append(html);
        }

        $(document).ready(function () {
            loadFaqs();

            // 검색 버튼 클릭 이벤트
            $('#searchBtn').on('click', function (e) {
                e.preventDefault();
                loadFaqs(1);
            });

            // 검색 입력창에서 Enter 키 이벤트
            $('#keyword').keypress(function (e) {
                if (e.which === 13) {
                    e.preventDefault();
                    loadFaqs(1);
                }
            });
        });
    </script>
</head>
<body>
<div class="container mt-5">
    <h3 class="fw-bold mb-4" style="color: darkgray">자주 묻는 질문 (FAQ)</h3>

    <form class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" id="searchType" class="form-select">
                <option value="faqTitle">제목</option>
                <option value="deptName">작성부서</option>
                <option value="all">제목+작성부서</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" id="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" id="searchBtn" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>
    <div class="accordion" id="faqAccordion">
    </div>

    <nav class="mt-4" id="paginationArea">
    </nav>
</div>
</body>
</html>