<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ 관리</title>
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
        // 새 창으로 폼을 여는 함수
        function goForm(url) {
            var op = "width=500,height=700,top=50,left=150";
            window.open(url, "", op);
        }

        // FAQ 목록을 불러오는 함수
        function loadFaqs(page) {
            if (!page) page = 1;
            var searchType = $('select[name="searchType"]').val();
            var keyword = $('input[name="keyword"]').val();

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
                    if (response.success) {
                        var faqList = response.data.faqList;
                        var pagination = response.data.pageDto;
                        var $accordion = $('#faqAccordion').empty();

                        if (faqList && faqList.length > 0) {
                            $.each(faqList, function (index, faq) {
                                var item = '';
                                item += '<div class="accordion-item mb-2">';
                                item += '<h2 class="accordion-header" id="heading' + faq.faqId + '">';
                                item += '<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"';
                                item += 'data-bs-target="#collapse' + faq.faqId + '" aria-expanded="false" aria-controls="collapse' + faq.faqId + '">';
                                item += faq.faqTitle;
                                item += '</button>';
                                item += '</h2>';
                                item += '<div id="collapse' + faq.faqId + '" class="accordion-collapse collapse" aria-labelledby="heading' + faq.faqId + '" data-bs-parent="#faqAccordion">';
                                item += '<div class="accordion-body">';
                                item += '<div class="faq-answer mb-2">' + faq.faqContent + '</div>';
                                item += '<div class="text-muted small">작성 부서: ' + faq.deptName + '</div>';
                                item += '<div class="mt-2">';
                                item += '<a onclick="goForm(\'getFaqEditForm?id=' + faq.faqId + '&page=' + pagination.page + '\')" class="btn btn-sm btn-outline-secondary">수정</a> ';
                                item += '<a href="deleteFaqByMng?id=' + faq.faqId + '&page=' + pagination.page + '" class="btn btn-sm btn-outline-danger" onclick="return confirm(\'정말 삭제하시겠습니까?\');">삭제</a>';
                                item += '</div>';
                                item += '</div>';
                                item += '</div>';
                                item += '</div>';
                                $accordion.append(item);
                            });
                        } else {
                            $accordion.append('<p class="text-muted">검색 결과가 없습니다.</p>');
                        }

                        renderPagination(pagination);
                    } else {
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('FAQ 데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        }

        // 페이징을 렌더링하는 함수
        function renderPagination(pagination) {
            var $paginationArea = $('#paginationArea').empty();
            if (!pagination) return;

            var html = '<ul class="pagination justify-content-center">';
            var currentPage = pagination.page;
            var startPage = pagination.startPage;
            var endPage = pagination.endPage;
            var totalPages = pagination.totalPages;

            // 이전 페이지 버튼
            var prevClass = currentPage > 1 ? '' : 'disabled';
            html += '<li class="page-item ' + prevClass + '"><a class="page-link" onclick="loadFaqs(' + (currentPage - 1) + ');">이전</a></li>';

            // 페이지 번호 버튼
            for (var i = startPage; i <= endPage; i++) {
                var activeClass = currentPage === i ? ' active' : '';
                html += '<li class="page-item' + activeClass + '">' +
                    '<a class="page-link" onclick="loadFaqs(' + i + ');">' + i + '</a>' +
                    '</li>';
            }

            // 다음 페이지 버튼
            var nextClass = currentPage < totalPages ? '' : 'disabled';
            html += '<li class="page-item ' + nextClass + '"><a class="page-link" onclick="loadFaqs(' + (currentPage + 1) + ');">다음</a></li>';

            html += '</ul>';
            $paginationArea.append(html);
        }

        $(document).ready(function () {
            // 페이지 로드 시 FAQ 목록 불러오기
            loadFaqs();

            // 검색 폼 제출 이벤트
            $('form').on('submit', function (e) {
                e.preventDefault();
                loadFaqs(1);
            });
        });
    </script>
</head>
<body>
<div class="container mt-5">
    <h3 class="fw-bold mb-4" style="color: darkgray">자주 묻는 질문 (FAQ)</h3>
    <div class="d-flex justify-content-end mb-3">
        <b onclick="goForm('getFaqForm')" class="btn btn-outline-primary fw-bold px-4 py-2 rounded-pill shadow-sm">
            <i class="bi bi-plus-circle me-2"></i> 자주 묻는 질문 등록
        </b>
    </div>

    <form class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="faqTitle">제목</option>
                <option value="deptName">작성부서</option>
                <option value="all">제목+작성부서</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <div class="accordion" id="faqAccordion">
    </div>

    <nav class="mt-4" id="paginationArea">
    </nav>
</div>
</body>
</html>