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
        /* 스타일 생략 (기존과 동일) */
        body { color: white; background-color: #1e1e1e; }
        .container { max-width: 900px; margin-top: 40px; }
        .form-template { margin-top: 20px; }
        .text-danger { color: #ff6b6b; font-size: 0.9rem; }
        .form-control, .form-select, select, input, textarea {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .form-select option, select option {
            background-color: #1e1e1e;
            color: white;
        }
        .table, .table-bordered th, .table-bordered td {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            border-color: rgba(255, 255, 255, 0.3) !important;
        }
        .select2-container--default .select2-selection--single {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            height: 38px;
            display: flex;
            align-items: center;
            padding-left: 0.75rem;
        }
        .select2-container--default .select2-results > .select2-results__options {
            background-color: #1e1e1e !important;
            color: white !important;
        }
        .select2-results__option--highlighted.select2-results__option--selectable {
            background-color: #0d6efd !important;
            color: white !important;
        }
        .select2-container--default .select2-results__option {
            background-color: #1e1e1e;
            color: white;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: white !important;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            top: 50%;
            transform: translateY(-50%);
        }
        .select2-search__field {
            background-color: #1e1e1e !important;
            color: white !important;
        }
        .form-select,
        .form-select,
        .select2-container--default .select2-selection--single,
        .select2-container {
            width: 100% !important;
        }
        .note-editor.note-frame {
            background-color: rgba(255, 255, 255, 0.05);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .note-editable {
            background-color: #2c2c2c;
            color: white;
        }
    </style>
</head>
<body>
<div class="container bg-glass p-4 shadow rounded">
    <h2 class="mb-4">결재문서 작성</h2>

    <form:form method="post" action="insertMyDraft" modelAttribute="draftFormDto" enctype="multipart/form-data">
        <form:errors cssClass="text-danger fw-bold fs-5" />
        <form:input type="hidden" path="docId"/>
        <form:input type="hidden" path="status"/>
        <!-- 결재양식 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">결재양식 선택 *</label>
            <form:select path="formCode" cssClass="form-select bg-glass" id="formTypeSelect">
                <form:option value="">양식을 선택하세요</form:option>
                <form:option value="app_01">휴가신청서</form:option>
                <form:option value="app_02">프로젝트 제안서</form:option>
                <form:option value="app_03">지출결의서</form:option>
                <form:option value="app_04">사직서</form:option>
            </form:select>
            <form:errors path="formCode" cssClass="text-danger" />
        </div>

        <!-- 결재자 선택 -->
        <div class="row mb-3 dependent-fields d-none">
            <div class="col-md-6 select-wrapper">
                <label class="form-label">1차 결재자 *</label>
                <form:select path="approver1" cssClass="form-select bg-glass employee-select">
                    <form:option value="">직원을 검색하세요</form:option>
                    <c:forEach var="m" items="${draftMembers}">
                        <form:option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</form:option>
                    </c:forEach>
                </form:select>
                <form:errors path="approver1" cssClass="text-danger" />
            </div>
            <div class="col-md-6 select-wrapper">
                <label class="form-label">2차 결재자 *</label>
                <form:select path="approver2" cssClass="form-select bg-glass employee-select">
                    <form:option value="">직원을 검색하세요</form:option>
                    <c:forEach var="m" items="${draftMembers}">
                        <form:option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</form:option>
                    </c:forEach>
                </form:select>
                <form:errors path="approver2" cssClass="text-danger" />
            </div>
        </div>

        <!-- 참조자(다중 선택, JS 사용) -->
        <div class="mb-3 select-wrapper dependent-fields d-none">
            <label class="form-label">참조자</label>
            <select class="form-select bg-glass employee-select" id="referrerSelect">
                <option value="">직원을 선택하세요</option>
                <c:forEach var="m" items="${draftMembers}">
                    <option value='{"id":"${m.memId}","dept":"${m.deptName}","role":"${m.rankName}","name":"${m.memName}","email":"${m.memEmail}"}'
                            <c:if test="${fn:contains(draftFormDto.referrers, m.memId)}">selected</c:if>
                    >[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3 dependent-fields d-none">
            <input type="text" id="referrerDisplay" class="form-control bg-glass" placeholder="선택된 참조자"/>
            <input type="hidden" name="referrers" id="referrersHidden" value="${draftFormDto.referrers}" />
        </div>

        <!-- 마감기한 -->
        <div class="mb-3 dependent-fields d-none">
            <label class="form-label">문서종료일 *</label>
            <input type="date" name="docEndDate" cssClass="form-control bg-glass" value="${draftFormDto.docEndDateStr}"/>
            <form:errors path="docEndDate" cssClass="text-danger" />
        </div>

        <!-- 휴가신청서 양식 -->
        <div id="app_01" class="form-template d-none">
            <h5>휴가신청서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>휴가 유형</th>
                    <td>
                        <form:select path="leaveCode" cssClass="form-select bg-glass">
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
                        <input type="date" name="leaveStart" class="bg-glass" value="${draftFormDto.leaveStartStr}" /> ~
                        <input type="date" name="leaveEnd" class="bg-glass" value="${draftFormDto.leaveEndStr}" />
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
                    <td><form:input path="projectName" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>예상 기간</th>
                    <td>
                        <input type="date" name="projectStart" class="bg-glass" value="${draftFormDto.projectStartStr}" /> ~
                        <input type="date" name="projectEnd" class="bg-glass" value="${draftFormDto.projectEndStr}" />
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
                    <td><form:input path="exName" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>금액</th>
                    <td><form:input type="number" path="exAmount" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>사용일자</th>
                    <td><form:input type="date" path="useDate" cssClass="form-control bg-glass" /></td>
                </tr>
            </table>
        </div>

        <!-- 사직서 양식 -->
        <div id="app_04" class="form-template d-none">
            <h5>사직서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>퇴사 희망일</th>
                    <td><form:input type="date" path="resignDate" cssClass="form-control bg-glass" /></td>
                </tr>
            </table>
        </div>

        <!-- 제목/내용/첨부 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">제목 *</label>
            <form:input path="title" cssClass="form-control bg-glass" />
            <form:errors path="title" cssClass="text-danger" />
        </div>
        <!-- 📌 Summernote 적용 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">내용 *</label>
            <textarea id="summerContent" name="content">${draftFormDto.content}</textarea>
            <form:errors path="content" cssClass="text-danger" />
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">첨부파일</label>
            <input type="file" class="form-control bg-glass" name="attachments" multiple>
        </div>
        <!-- 첨부파일 존재시 -->
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
            <button type="submit" name="action" value="save" class="btn btn-primary bg-glass">제출</button>
            <button type="submit" name="action" value="temporary" class="btn btn-secondary bg-glass">임시저장</button>
            <a href="getMyDraftList" class="btn btn-light bg-glass">목록으로</a>
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

        // 참조자(다중) 처리
        $('#referrerSelect').on('change', function () {
            const raw = $(this).val();
            if (!raw) return;
            const emp = JSON.parse(raw);
            const formatted = "[" + emp.dept + ", " + emp.role + "]" + emp.name + "<" + emp.email + ">";
            const display = $('#referrerDisplay');
            const hidden = $('#referrersHidden');

            if (!hidden.val().includes(emp.id)) {
                display.val(display.val() ? display.val() + ', ' + formatted : formatted);
                hidden.val(hidden.val() ? hidden.val() + ',' + emp.id : emp.id);
            }
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
