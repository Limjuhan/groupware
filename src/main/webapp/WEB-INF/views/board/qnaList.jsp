<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>질문 게시판</title>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            max-width: 960px;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .question-title {
            text-align: left;
            padding-left: 1rem;
        }

        .page-link {
            cursor: pointer;
        }
    </style>
    <script>
        function goForm(url) {
            var op = "width=500,height=700,top=50,left=150";
            window.open(url, "", op);
        }

        // QnA 목록을 불러오는 함수
        function loadQnaList(page) {
            if (!page) page = 1;
            var searchType = $('select[name="searchType"]').val();
            var keyword = $('input[name="keyword"]').val();

            $.ajax({
                url: '/api/qna/qnaList',
                type: 'GET',
                data: {
                    page: page,
                    searchType: searchType,
                    keyword: keyword
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        var qnaList = response.data.qna;
                        var pagination = response.data.pageDto;
                        var $tbody = $('#qnaTableBody').empty();

                        if (qnaList && qnaList.length > 0) {
                            $.each(qnaList, function (index, q) {
                                var qnaRow = '';
                                qnaRow += '<tr>';
                                qnaRow += '<td>' + q.qnaId + '</td>';
                                qnaRow += '<td class="question-title">';
                                qnaRow += '<a href="getQnaDetail?id=' + q.qnaId + '" class="text-decoration-none">' + q.qnaTitle + '</a>';
                                qnaRow += '</td>';
                                qnaRow += '<td>' + q.memName + '</td>';
                                qnaRow += '<td>' + q.updatedAtStr + '</td>';
                                qnaRow += '</tr>';
                                $tbody.append(qnaRow);
                            });
                        } else {
                            $tbody.append('<tr><td colspan="4" class="text-muted">게시물이 없습니다.</td></tr>');
                        }

                        renderPagination(pagination);
                        // FAQ 데이터도 함께 불러와 모달에 표시
                        renderFaq(response.data.faq);
                    } else {
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('질문 게시판 데이터를 불러오는 중 오류가 발생했습니다.');
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
            html += '<li class="page-item ' + prevClass + '"><a class="page-link" onclick="loadQnaList(' + (currentPage - 1) + ');">이전</a></li>';

            // 페이지 번호 버튼
            for (var i = startPage; i <= endPage; i++) {
                var activeClass = currentPage === i ? ' active' : '';
                html += '<li class="page-item' + activeClass + '">' +
                    '<a class="page-link" onclick="loadQnaList(' + i + ');">' + i + '</a>' +
                    '</li>';
            }

            // 다음 페이지 버튼
            var nextClass = currentPage < totalPages ? '' : 'disabled';
            html += '<li class="page-item ' + nextClass + '"><a class="page-link" onclick="loadQnaList(' + (currentPage + 1) + ');">다음</a></li>';

            html += '</ul>';
            $paginationArea.append(html);
        }

        // FAQ 모달에 FAQ 목록을 렌더링하는 함수
        function renderFaq(faqList) {
            var $faqAccordion = $('#faqAccordion').empty();
            if (faqList && faqList.length > 0) {
                $.each(faqList, function (index, f) {
                    var faqItem = '';
                    faqItem += '<div class="accordion-item">';
                    faqItem += '<h2 class="accordion-header" id="heading' + index + '">';
                    faqItem += '<button class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#collapse' + index + '">';
                    faqItem += f.faqTitle;
                    faqItem += '</button>';
                    faqItem += '</h2>';
                    faqItem += '<div id="collapse' + index + '" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">';
                    faqItem += '<div class="accordion-body">' + f.faqContent + '</div>';
                    faqItem += '</div>';
                    faqItem += '</div>';
                    $faqAccordion.append(faqItem);
                });
            } else {
                $faqAccordion.append('<div class="p-3 text-muted">등록된 FAQ가 없습니다.</div>');
            }
        }

        $(document).ready(function () {
            loadQnaList(1);

            $('form').on('submit', function (e) {
                e.preventDefault();
                loadQnaList(1);
            });
        });
    </script>
</head>
<body>
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">질문 게시판</h3>
        <div>
            <button type="button" class="btn btn-outline-info me-2" data-bs-toggle="modal" data-bs-target="#faqModal">
                자주 묻는 질문
            </button>
            <a onclick="goForm('getQnaForm')" class="btn btn-primary">질문하기</a>
        </div>
    </div>

    <form class="row g-2 mb-4">
        <div class="col-md-3">
            <select name="searchType" class="form-select">
                <option value="qnaTitle">제목</option>
                <option value="memId">작성자</option>
                <option value="all">제목+작성자</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="keyword" class="form-control" placeholder="검색어를 입력하세요">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-outline-secondary w-100">검색</button>
        </div>
    </form>

    <table class="table table-bordered table-hover bg-white">
        <thead class="table-light">
        <tr>
            <th style="width: 10%;">번호</th>
            <th style="width: 50%;">제목</th>
            <th style="width: 20%;">작성자</th>
            <th style="width: 20%;">작성일</th>
        </tr>
        </thead>
        <tbody id="qnaTableBody">
        </tbody>
    </table>

    <nav class="mt-4" id="paginationArea">
    </nav>
</div>

<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">자주 묻는 질문 (FAQ)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <div class="accordion" id="faqAccordion">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>