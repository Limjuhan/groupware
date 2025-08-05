<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결재문서 작성 - LDBSOFT</title>
    <!-- Summernote -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/lang/summernote-ko-KR.min.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        /* Select wrapper 스타일링 */
        .select-wrapper {
            position: relative;
            margin-bottom: 1rem;
        }

        /* Select2 드롭다운 스타일 */
        .select2-container--default .select2-selection--single {
            height: calc(2.25rem + 2px);
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            background-color: #fff;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        /* Select2 드롭다운 폭 조정 */
        .select2-container {
            width: 100% !important;
        }

        .select2-container--default .select2-dropdown {
            min-width: 300px !important; /* 드롭다운 최소 폭 확장 */
            max-width: 500px !important; /* 드롭다운 최대 폭 제한 */
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
        }

        .select2-container--default .select2-results__option {
            font-size: 0.875rem;
            padding: 0.5rem;
            white-space: normal; /* 텍스트 줄바꿈 허용 */
        }

        /* Select2 포커스 및 호버 */
        .select2-container--default .select2-selection--single:focus,
        .select2-container--default .select2-selection--single:hover {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        /* Select2 화살표 */
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: calc(2.25rem + 2px);
            top: 0;
            right: 10px;
        }

        /* Select2 플레이스홀더 */
        .select2-container--default .select2-selection--single .select2-selection__placeholder {
            color: #6c757d;
        }

        /* 결재자 및 참조자 테이블 스타일 */
        .approver-table, .referrer-table {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            margin-bottom: 1rem;
        }

        .approver-table th, .referrer-table th {
            background-color: #f8f9fa;
            font-weight: 500;
            color: #333;
            padding: 0.75rem;
            vertical-align: middle;
            border-bottom: 1px solid #dee2e6;
            width: 20%;
        }

        .approver-table td, .referrer-table td {
            padding: 0.75rem;
            vertical-align: middle;
            border-bottom: 1px solid #dee2e6;
        }

        /* 참조자 표시 영역 */
        #referrerDisplay {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            min-height: 2.5rem;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            padding: 0.5rem;
        }

        /* 참조자 아이템 */
        .referrer-item {
            background-color: #e9ecef;
            border-radius: 0.25rem;
            padding: 0.25rem 0.5rem;
            margin: 0.25rem;
            font-size: 0.875rem;
            color: #333;
            display: inline-flex;
            align-items: center;
        }

        /* 참조자 삭제 버튼 */
        .referrer-item .btn-remove {
            cursor: pointer;
            color: #dc3545;
            margin-left: 0.5rem;
            font-size: 1rem;
            transition: color 0.2s ease;
        }

        .referrer-item .btn-remove:hover {
            color: #b02a37;
        }

        /* 에러 메시지 */
        .text-danger {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        /* 반응형 조정 */
        @media (max-width: 768px) {
            .select2-container--default .select2-selection--single {
                font-size: 0.875rem;
            }

            .select2-container--default .select2-dropdown {
                min-width: 200px !important; /* 모바일에서 드롭다운 폭 조정 */
            }

            .referrer-item {
                font-size: 0.75rem;
            }

            .approver-table th, .approver-table td,
            .referrer-table th, .referrer-table td {
                padding: 0.5rem;
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body>
<div class="container p-4 rounded">
    <h2 class="mb-4">결재문서 작성</h2>

    <form:form method="post" action="insertMyDraft" modelAttribute="draftFormDto" enctype="multipart/form-data">
        <form:errors path="" cssClass="text-danger fw-bold fs-5" />
        <form:input type="hidden" path="docId"/>
        <form:input type="hidden" path="status"/>
        <input type="hidden" name="savedFormCode" value="${draftFormDto.formCode}">
        <!-- 결재양식 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">결재양식 선택 *</label>
            <form:select path="formCode" cssClass="form-select" id="formTypeSelect">
                <form:option value="">양식을 선택하세요</form:option>
                <form:option value="app_01">휴가신청서</form:option>
                <form:option value="app_02">프로젝트 제안서</form:option>
                <form:option value="app_03">지출결의서</form:option>
                <form:option value="app_04">사직서</form:option>
            </form:select>
            <form:errors path="formCode" cssClass="text-danger" />
        </div>

        <!-- 결재자 선택 -->
        <div class="mb-3 dependent-fields d-none">
            <table class="table table-bordered approver-table">
                <tr>
                    <th>1차 결재자 *</th>
                    <td>
                        <div class="select-wrapper">
                            <form:select path="approver1" cssClass="form-select employee-select">
                                <form:option value="">직원을 검색하세요</form:option>
                                <c:forEach var="m" items="${draftMembers}">
                                    <form:option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</form:option>
                                </c:forEach>
                            </form:select>
                            <form:errors path="approver1" cssClass="text-danger" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>2차 결재자 *</th>
                    <td>
                        <div class="select-wrapper">
                            <form:select path="approver2" cssClass="form-select employee-select">
                                <form:option value="">직원을 검색하세요</form:option>
                                <c:forEach var="m" items="${draftMembers}">
                                    <form:option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</form:option>
                                </c:forEach>
                            </form:select>
                            <form:errors path="approver2" cssClass="text-danger" />
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <!-- 참조자 -->
        <div class="mb-3 dependent-fields d-none">
            <table class="table table-bordered referrer-table">
                <tr>
                    <th>참조자</th>
                    <td>
                        <div class="select-wrapper">
                            <select class="form-select employee-select" id="referrerSelect">
                                <option value="">직원을 선택하세요</option>
                                <c:forEach var="m" items="${draftMembers}">
                                    <option value='{"id":"${m.memId}","dept":"${m.deptName}","role":"${m.rankName}","name":"${m.memName}","email":"${m.memEmail}"}'
                                            <c:if test="${fn:contains(draftFormDto.referrers, m.memId)}">selected</c:if>
                                    >[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div id="referrerDisplay" class="p-2"></div>
                        <input type="hidden" name="referrers" id="referrersHidden" value="${draftFormDto.referrers}" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- 마감기한 -->
        <div class="mb-3 dependent-fields d-none">
            <label class="form-label">문서종료일 *</label>
            <input type="date" name="docEndDate" cssClass="form-control" value="${draftFormDto.docEndDateStr}"/>
            <form:errors path="docEndDate" cssClass="text-danger" />
        </div>

        <!-- 휴가신청서 양식 -->
        <div id="app_01" class="form-template d-none">
            <h5>휴가신청서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>휴가 유형</th>
                    <td>
                        <form:select path="leaveCode" cssClass="form-select">
                            <form:option value="">선택</form:option>
                            <form:option value="ANNUAL">연차</form:option>
                            <form:option value="HALF">반차</form:option>
                            <form:option value="EVENT">경조사</form:option>
                        </form:select>
                        <form:errors path="leaveCode" cssClass="text-danger" />
                    </td>
                </tr>
                <tr>
                    <th>휴가 기간</th>
                    <td>
                        <input type="date" name="leaveStart" class="" value="${draftFormDto.leaveStartStr}" /> ~
                        <input type="date" name="leaveEnd" class="" value="${draftFormDto.leaveEndStr}" />
                        <form:errors path="leaveStart" cssClass="text-danger" />
                        <form:errors path="leaveEnd" cssClass="text-danger" />
                    </td>
                </tr>
                <tr>
                    <th>잔여 연차</th>
                    <td>${remainAnnual}일</td>
                </tr>
            </table>
        </div>

        <!-- 프로젝트 제안서 양식 -->
        <div id="app_02" class="form-template d-none">
            <h5>프로젝트 제안서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>프로젝트명</th>
                    <td><form:input path="projectName" cssClass="form-control" /></td>
                </tr>
                <tr>
                    <th>예상 기간</th>
                    <td>
                        <input type="date" name="projectStart" class="" value="${draftFormDto.projectStartStr}" /> ~
                        <input type="date" name="projectEnd" class="" value="${draftFormDto.projectEndStr}" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- 지출결의서 양식 -->
        <div id="app_03" class="form-template d-none">
            <h5>지출결의서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>지출 항목</th>
                    <td><form:input path="exName" cssClass="form-control" /></td>
                </tr>
                <tr>
                    <th>금액</th>
                    <td><form:input type="number" path="exAmount" cssClass="form-control" /></td>
                </tr>
                <tr>
                    <th>사용일자</th>
                    <td><form:input type="date" path="useDate" cssClass="form-control" /></td>
                </tr>
            </table>
        </div>

        <!-- 사직서 양식 -->
        <div id="app_04" class="form-template d-none">
            <h5>사직서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>퇴사 희망일</th>
                    <td><form:input type="date" path="resignDate" cssClass="form-control" /></td>
                </tr>
            </table>
        </div>

        <!-- 제목/내용/첨부 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">제목 *</label>
            <form:input path="title" cssClass="form-control" />
            <form:errors path="title" cssClass="text-danger" />
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">내용 *</label>
            <textarea id="summerContent" name="content">${draftFormDto.content}</textarea>
            <form:errors path="content" cssClass="text-danger" />
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">첨부파일</label>
            <input type="file" class="form-control" name="attachments" multiple>
        </div>
        <c:if test="${not empty attachments}">
            <div class="mt-2">
                <label class="form-label">등록된 첨부파일</label>
                <ul class="list-unstyled">
                    <c:forEach var="file" items="${attachments}">
                        <li class="mb-1 attach-item" data-id="${file.savedName}">
                            <a href="/upload/${file.filePath}/${file.savedName}" download="${file.originalName}" class="link-light">
                                <i class="bi bi-paperclip"></i> ${file.originalName}
                            </a>
                            <button type="button" class="btn btn-sm btn-danger ms-2"
                                    onclick="deleteAttachment('${file.savedName}', '${file.attachType}')">삭제</button>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- 제출 버튼 -->
        <div class="text-end mt-4">
            <button type="submit" name="action" value="save" class="btn btn-primary">제출</button>
            <button type="submit" name="action" value="temporary" class="btn btn-secondary">임시저장</button>
            <a href="getMyDraftList" class="btn btn-light">목록으로</a>
        </div>
    </form:form>
</div>

<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function () {
        // 에러발생시 alert
        var errorMessage = '${globalError}';
        if (errorMessage !== '') {
            alert(errorMessage);
        }

        $('.employee-select').select2({ placeholder: '직원 검색...', allowClear: true });

        // 1차 결재자 변경 시
        $("select[name='approver1']").on("change", function () {
            const approver1 = $(this).val();
            const approver2 = $("select[name='approver2']").val();
            const referrers = $("#referrersHidden").val()?.split(",") || [];

            if (approver1 && approver1 === approver2) {
                alert("1차 결재자와 2차 결재자가 같을 수 없습니다.");
                $(this).val("").trigger("change");
                return;
            }
            if (approver1 && referrers.includes(approver1)) {
                alert("1차 결재자가 참조자에 포함될 수 없습니다.");
                $(this).val("").trigger("change");
                return;
            }
        });

        // 2차 결재자 변경 시
        $("select[name='approver2']").on("change", function () {
            const approver2 = $(this).val();
            const approver1 = $("select[name='approver1']").val();
            const referrers = $("#referrersHidden").val()?.split(",") || [];

            if (approver2 && approver2 === approver1) {
                alert("2차 결재자와 1차 결재자가 같을 수 없습니다.");
                $(this).val("").trigger("change");
                return;
            }
            if (approver2 && referrers.includes(approver2)) {
                alert("2차 결재자가 참조자에 포함될 수 없습니다.");
                $(this).val("").trigger("change");
                return;
            }
        });

        // 초기 참조자 표시
        updateReferrerDisplay();

        // 참조자 추가 처리
        $('#referrerSelect').on('change', function () {
            const raw = $(this).val();
            if (!raw) return;
            const emp = JSON.parse(raw);
            const approver1 = $("select[name='approver1']").val();
            const approver2 = $("select[name='approver2']").val();
            const hidden = $('#referrersHidden');
            const referrers = hidden.val()?.split(",").filter(id => id) || [];

            // 결재자 중복체크
            if (emp.id === approver1 || emp.id === approver2) {
                alert("참조자는 1차/2차 결재자와 중복될 수 없습니다.");
                $(this).val("").trigger("change");
                return;
            }

            if (!referrers.includes(emp.id)) {
                referrers.push(emp.id);
                hidden.val(referrers.join(","));
                updateReferrerDisplay();
            }
            $(this).val("").trigger("change"); // 선택 후 초기화
        });

        // 참조자 삭제 처리
        $(document).on('click', '.btn-remove', function () {
            var memId = $(this).data('id');
            var hidden = $('#referrersHidden');
            var referrers = hidden.val() ? hidden.val().split(",") : [];
            referrers = referrers.filter(function (id) {
                return id !== memId;
            });
            hidden.val(referrers.join(","));
            updateReferrerDisplay();
        });

        // 최초 진입, validation 실패 시에도 기존 선택값에 따라 표시
        let selectedFormType = $('#formTypeSelect').val();
        if (selectedFormType) showFormTemplate(selectedFormType);

        $('#formTypeSelect').on('change', function () {
            showFormTemplate($(this).val());
        });

        $('#summerContent').summernote({
            height: 300,
            lang: 'ko-KR',
            placeholder: '내용을 입력하세요...',
            toolbar: [
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['fontsize', 'color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['link', 'picture']],
                ['view', ['codeview']]
            ]
        });
    });

    // 참조자 표시 업데이트
    function updateReferrerDisplay() {
        var hidden = $('#referrersHidden').val();
        var display = $('#referrerDisplay');
        var referrers = [];

        // 숨겨진 입력 값이 있으면 배열로 나누기
        if (hidden) {
            referrers = hidden.split(",");
        }

        // 표시 영역 비우기
        display.empty();

        // select 옵션 순회
        $('#referrerSelect option').each(function() {
            var option = $(this);
            var emp = {};
            if (option.val()) {
                emp = JSON.parse(option.val());
            }

            // 참조자 목록에 ID가 있으면 표시
            if (emp.id && referrers.indexOf(emp.id) > -1) {
                var formatted = "[" + emp.dept + ", " + emp.role + "]" + emp.name + "<" + emp.email + ">";
                var span = $('<span class="referrer-item"></span>').text(formatted);
                var removeIcon = $('<i class="bi bi-x btn-remove"></i>').data('id', emp.id);
                span.append(removeIcon);
                display.append(span);
            }
        });
    }

    // 양식 선택 시 양식 영역 표시 + 기존 선택 유지
    function showFormTemplate(selected) {
        $('.form-template').addClass('d-none');
        $('.dependent-fields').removeClass('d-none');

        if (selected) {
            $('#' + selected).removeClass('d-none');
            $("input[name='title']").closest('.form-template').removeClass('d-none');
            $("textarea[name='content']").closest('.form-template').removeClass('d-none');
            $("input[name='attachments']").closest('.form-template').removeClass('d-none');
        } else {
            $('.dependent-fields').addClass('d-none');
        }
    }

    // 첨부파일 삭제
    function deleteAttachment(savedName, attachType) {
        if (!confirm("첨부파일을 삭제하시겠습니까?")) return;

        $.ajax({
            type: "POST",
            url: "/draft/deleteAttachment",
            data: {
                savedName: savedName,
                attachType: attachType
            },
            success: function (res) {
                if (res.success) {
                    $(".attach-item[data-id='" + savedName + "']").remove();
                } else {
                    alert("삭제 실패: " + res.message);
                }
            },
            error: function () {
                alert("삭제 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>