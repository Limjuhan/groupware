<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        /* select2 기본 선택창 */
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

        /* 드롭다운 영역 배경 및 글씨색 */
        .select2-container--default .select2-results > .select2-results__options {
            background-color: #1e1e1e !important;
            color: white !important;
        }

        /* 선택 옵션 hover 시 */
        .select2-results__option--highlighted.select2-results__option--selectable {
            background-color: #0d6efd !important;
            color: white !important;
        }

        /* 드롭다운 텍스트 */
        .select2-container--default .select2-results__option {
            background-color: #1e1e1e;
            color: white;
        }

        /* 선택창 내부 텍스트 */
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: white !important;
        }

        /* 드롭다운 화살표 */
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            top: 50%;
            transform: translateY(-50%);
        }

    </style>
</head>
<body>
<div class="container bg-glass p-4 shadow rounded">
    <h2 class="mb-4">결재문서 작성</h2>

    <form method="post" action="insertMyDraft" enctype="multipart/form-data">
        <!-- 결재양식 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">결재양식 선택 *</label>
            <select name="formType" class="form-select bg-glass" id="formTypeSelect">
                <option value="">양식을 선택하세요</option>
                <option value="app_01">휴가신청서</option>
                <option value="app_02">프로젝트 제안서</option>
                <option value="app_03">지출결의서</option>
                <option value="app_04">사직서</option>
            </select>
            <c:if test="${errors['formType'] != null}">
                <div class="text-danger">${errors['formType']}</div>
            </c:if>
        </div>

        <!-- 결재자 선택 -->
        <div class="row mb-3">
            <div class="col-md-6 select-wrapper">
                <label class="form-label">1차 결재자 *</label>
                <select name="approver1" class="form-select bg-glass employee-select">
                    <option value="">직원을 검색하세요</option>
                    <c:forEach var="m" items="${draftMembers}">
                        <option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</option>
                    </c:forEach>
                </select>
                <c:if test="${errors['approver1'] != null}">
                    <div class="text-danger">${errors['approver1']}</div>
                </c:if>
            </div>
            <div class="col-md-6 select-wrapper">
                <label class="form-label">2차 결재자 *</label>
                <select name="approver2" class="form-select bg-glass employee-select">
                    <option value="">직원을 검색하세요</option>
                    <c:forEach var="m" items="${draftMembers}">
                        <option value="${m.memId}">[${m.deptName}, ${m.rankName}]${m.memName}&lt;${m.memEmail}&gt;</option>
                    </c:forEach>
                </select>
                <c:if test="${errors['approver2'] != null}">
                    <div class="text-danger">${errors['approver2']}</div>
                </c:if>
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
            <input type="hidden" name="referrers" id="referrersHidden">
        </div>

        <!-- 마감기한 -->
        <div class="mb-3">
            <label class="form-label">문서종료일 *</label>
            <input type="date" name="deadline" class="form-control bg-glass" />
            <c:if test="${errors['deadline'] != null}">
                <div class="text-danger">${errors['deadline']}</div>
            </c:if>
        </div>

        <!-- 휴가신청서 양식 -->
        <div id="app_01" class="form-template d-none">
            <h5>휴가신청서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>휴가 유형</th>
                    <td>
                        <select name="leaveType" class="form-select bg-glass">
                            <option value="연차">연차</option>
                            <option value="반차">반차</option>
                            <option value="경조사">경조사</option>
                            <option value="병가">병가</option>
                        </select>
                        <c:if test="${errors['leaveType'] != null}">
                            <div class="text-danger">${errors['leaveType']}</div>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th>휴가 기간</th>
                    <td>
                        <input type="date" name="leaveStart" class="bg-glass" /> ~
                        <input type="date" name="leaveEnd" class="bg-glass" />
                        <c:if test="${errors['leaveStart'] != null}">
                            <div class="text-danger">${errors['leaveStart']}</div>
                        </c:if>
                        <c:if test="${errors['leaveEnd'] != null}">
                            <div class="text-danger">${errors['leaveEnd']}</div>
                        </c:if>
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
                    <td><input type="text" name="projectTitle" class="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>예상 기간</th>
                    <td><input type="text" name="expectedDuration" class="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>목표</th>
                    <td><textarea name="projectGoal" class="form-control bg-glass" rows="3"></textarea></td>
                </tr>
            </table>
        </div>

        <!-- 지출결의서 양식 -->
        <div id="app_03" class="form-template d-none">
            <h5>지출결의서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>지출 항목</th>
                    <td><input type="text" name="expenseItem" class="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>금액</th>
                    <td><input type="number" name="amount" class="form-control bg-glass" /></td>
                </tr>
                <tr>
                    <th>사용일자</th>
                    <td><input type="date" name="usedDate" class="form-control bg-glass" /></td>
                </tr>
            </table>
        </div>

        <!-- 사직서 양식 -->
        <div id="app_04" class="form-template d-none">
            <h5>사직서 양식</h5>
            <table class="table table-bordered">
                <tr>
                    <th>퇴사 희망일</th>
                    <td><input type="date" name="resignDate" class="form-control bg-glass" /></td>
                </tr>
<%--                <tr>--%>
<%--                    <th>사유</th>--%>
<%--                    <td><textarea name="resignReason" class="form-control bg-glass" rows="3"></textarea></td>--%>
<%--                </tr>--%>
            </table>
        </div>

        <!-- 제목/내용/첨부 -->
        <div class="mb-3 form-template d-none">
            <label class="form-label">제목 *</label>
            <input type="text" name="title" class="form-control bg-glass" />
            <c:if test="${errors['title'] != null}">
                <div class="text-danger">${errors['title']}</div>
            </c:if>
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">내용 *</label>
            <textarea name="content" class="form-control bg-glass" rows="5"></textarea>
            <c:if test="${errors['content'] != null}">
                <div class="text-danger">${errors['content']}</div>
            </c:if>
        </div>
        <div class="mb-3 form-template d-none">
            <label class="form-label">첨부파일</label>
            <input type="file" class="form-control bg-glass" name="attachments">
        </div>

        <!-- 제출 버튼 -->
        <div class="text-end mt-4">
            <button type="submit" name="action" value="save" class="btn btn-primary bg-glass">제출</button>
            <button type="submit" name="action" value="draft" class="btn btn-secondary bg-glass">임시저장</button>
            <a href="draftList" class="btn btn-light bg-glass">취소</a>
        </div>
    </form>
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
