<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결재문서 작성 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        body { color: white; background-color: #1e1e1e; }
        .container { max-width: 900px; margin-top: 40px; }
        .form-template { margin-top: 20px; }
        .text-danger { color: #ff6b6b; font-size: 0.9rem; }

        .form-control,
        .form-select,
        select,
        input,
        textarea {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .form-select option,
        select option {
            background-color: #1e1e1e;
            color: white;
        }

        table.table-bordered,
        .table-bordered th,
        .table-bordered td,
        .table th,
        .table td {
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

        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: white !important;
            line-height: 38px;
        }

        .select2-container--default .select2-selection--single .select2-selection__arrow {
            top: 50% !important;
            transform: translateY(-50%);
        }

        .select2-dropdown {
            background-color: rgba(0, 0, 0, 0.9) !important;
            color: white !important;
        }

        .select2-results__option--highlighted {
            background-color: #0d6efd !important;
            color: white !important;
        }
    </style>
</head>
<body>
<div class="container bg-glass p-4 shadow rounded">
    <h2 class="mb-4">결재문서 작성</h2>

    <form:form method="post" action="insertMyDraft" modelAttribute="draftFormDto" enctype="multipart/form-data">
        <!-- 글로벌 에러 -->
        <form:errors cssClass="text-danger" element="div" />

        <!-- 결재양식 선택 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">결재양식 선택 *</label>
            <form:select path="formType" cssClass="form-select bg-glass" id="formTypeSelect">
                <form:option value="">양식을 선택하세요</form:option>
                <form:option value="app_01">휴가신청서</form:option>
                <form:option value="app_02">프로젝트 제안서</form:option>
                <form:option value="app_03">지출결의서</form:option>
                <form:option value="app_04">사직서</form:option>
            </form:select>
            <form:errors path="formType" cssClass="text-danger" />
        </div>

        <!-- 결재자 선택 -->
        <div class="row mb-3">
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

        <!-- 참조자 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">참조자</label>
            <select class="form-select bg-glass employee-select" id="referrerSelect">
                <option value="">직원을 선택하세요</option>
                <c:forEach var="m" items="${draftMembers}">
                    <option value='{"id":"${m.memId}","dept":"${m.deptName}","role":"${m.rankName}","name":"${m.memName}","email":"${m.memEmail}"}'>
                        [${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <input type="text" id="referrerDisplay" class="form-control bg-glass" placeholder="선택된 참조자" readonly>
            <form:input path="referrers" type="hidden" id="referrersHidden" />
        </div>

        <!-- 마감기한 -->
        <div class="mb-3">
            <label class="form-label">문서종료일 *</label>
            <form:input path="deadline" type="date" cssClass="form-control bg-glass" />
            <form:errors path="deadline" cssClass="text-danger" />
        </div>

        <!-- 휴가신청서 양식 -->
        <div id="app_01" class="form-template d-none">
            <h5>휴가신청서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>휴가 유형</th>
                    <td>
                        <form:select path="leaveType" cssClass="form-select bg-glass">
                            <form:option value="연차" />
                            <form:option value="반차" />
                            <form:option value="경조사" />
                            <form:option value="병가" />
                        </form:select>
                        <form:errors path="leaveType" cssClass="text-danger" />
                    </td>
                </tr>
                <tr>
                    <th>휴가 기간</th>
                    <td>
                        <form:input path="leaveStart" type="date" cssClass="bg-glass" /> ~
                        <form:input path="leaveEnd" type="date" cssClass="bg-glass" />
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
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>프로젝트명</th>
                    <td><form:input path="projectTitle" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>예상 기간</th>
                    <td><form:input path="expectedDuration" cssClass="form-control bg-glass" placeholder="예: 2025.01 ~ 2025.06" /></td>
                </tr>
                <tr>
                    <th>목표</th>
                    <td><form:textarea path="projectGoal" cssClass="form-control bg-glass" rows="3" /></td>
                </tr>
            </table>
        </div>

        <!-- 지출결의서 양식 -->
        <div id="app_03" class="form-template d-none">
            <h5>지출결의서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>지출 항목</th>
                    <td><form:input path="expenseItem" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>금액</th>
                    <td><form:input path="amount" type="number" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>사용일자</th>
                    <td><form:input path="usedDate" type="date" cssClass="form-control bg-glass" /></td>
                </tr>
            </table>
        </div>

        <!-- 사직서 양식 -->
        <div id="app_04" class="form-template d-none">
            <h5>사직서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>퇴사 희망일</th>
                    <td><form:input path="resignDate" type="date" cssClass="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>사유</th>
                    <td><form:textarea path="resignReason" cssClass="form-control bg-glass" rows="3" /></td>
                </tr>
            </table>
        </div>

        <!-- 제목 & 내용 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">제목 *</label>
            <form:input path="title" cssClass="form-control bg-glass" />
            <form:errors path="title" cssClass="text-danger" />
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">내용 *</label>
            <form:textarea path="content" rows="5" cssClass="form-control bg-glass" />
            <form:errors path="content" cssClass="text-danger" />
        </div>

        <!-- 첨부파일 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">첨부파일</label>
            <input type="file" class="form-control bg-glass" name="attachments">
        </div>

        <!-- 제출 -->
        <div class="text-end mt-4">
            <button type="submit" name="action" value="save" class="btn btn-primary bg-glass">제출</button>
            <button type="submit" name="action" value="draft" class="btn btn-secondary bg-glass">임시저장</button>
            <a href="draftList" class="btn btn-light bg-glass">취소</a>
        </div>
    </form:form>


</div>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function () {
        $('.employee-select').select2({ placeholder: '직원 검색...', allowClear: true });
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

        $('#formTypeSelect').on('change', function () {
            const selected = $(this).val();
            $('.form-template').addClass('d-none');
            if (selected) {
                $('#' + selected).removeClass('d-none');
                $("input[name='title']").closest('.form-template').removeClass('d-none');
                $("textarea[name='content']").closest('.form-template').removeClass('d-none');
                $("input[name='attachments']").closest('.form-template').removeClass('d-none');
            }
        });
    });
</script>
</body>
</html>
