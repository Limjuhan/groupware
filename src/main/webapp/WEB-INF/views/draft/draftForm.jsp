<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결재문서 작성 - LDBSOFT</title>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        body {
            color: white;
        }

        .container {
            max-width: 900px;
            margin-top: 40px;
        }

        .form-template {
            margin-top: 20px;
        }

        .table.bg-glass td, .table.bg-glass th {
            background: rgba(255, 255, 255, 0.05) !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            color: white;
        }

        /* ▼ select 화살표 스타일 */
        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: "▼";
            position: absolute;
            top: 65%;
            right: 1.0rem;
            transform: translateY(-40%);
            pointer-events: none;
            color: white;
            font-size: 1.2rem;
        }

        .form-select.bg-glass option {
            background-color: #ffffff;
            color: #000000;
        }

        /* select2 외부 박스 투명 처리 */
        .select2-container--default .select2-selection--single {
            background: rgba(255, 255, 255, 0.05) !important;
            color: white !important;
            backdrop-filter: blur(1px);
            -webkit-backdrop-filter: blur(1px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            height: 38px;
            display: flex;
            align-items: center;
            padding-left: 0.75rem;
        }

        /* 선택된 텍스트 */
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: white !important;
            line-height: 38px;
        }

        /* 화살표 아이콘 위치 */
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            top: 50% !important;
            transform: translateY(-50%);
        }

        /* 드롭다운 항목 배경 */
        .select2-dropdown {
            background-color: rgba(0, 0, 0, 0.85) !important;
            color: white !important;
        }

        /* 항목 hover 시 강조 */
        .select2-results__option--highlighted {
            background-color: #0d6efd !important;
            color: white !important;
        }

    </style>
</head>
<body>

<div class="container bg-glass p-4 shadow rounded">
    <h2 class="mb-4">결재문서 작성</h2>

    <form method="post" action="draftForm" enctype="multipart/form-data">
        <!-- 결재양식 선택 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">결재양식 선택 *</label>
            <select class="form-select bg-glass" id="formTypeSelect" name="formType" required onchange="showFormTemplate()">
                <option value="">양식을 선택하세요</option>
                <option value="휴가신청서">휴가신청서</option>
                <option value="지출결의서">지출결의서</option>
                <option value="프로젝트제안서">프로젝트 제안서</option>
            </select>
        </div>

        <!-- 결재자 선택 -->
        <div class="row mb-3">
            <div class="col-md-6 select-wrapper">
                <label class="form-label">1차 결재자 *</label>
                <select class="form-select bg-glass employee-select" name="approver1" required>
                    <option value="">직원을 검색하세요</option>
                    <option value="emp001">[웹개발팀, 사원]김사원&lt;ttt@ldb.com&gt;</option>
                    <option value="emp002">[운영팀, 부장]박부장&lt;ppp@ldb.com&gt;</option>
                    <option value="emp003">[인사팀, 대리]이대리&lt;eee@ldb.com&gt;</option>
                    <option value="emp004">[고객지원팀, 과장]홍과장&lt;hhh@ldb.com&gt;</option>
                </select>
            </div>
            <div class="col-md-6 select-wrapper">
                <label class="form-label">2차 결재자 *</label>
                <select class="form-select bg-glass employee-select" name="approver2" required>
                    <option value="">직원을 검색하세요</option>
                    <option value="emp001">[웹개발팀, 사원]김사원&lt;ttt@ldb.com&gt;</option>
                    <option value="emp002">[운영팀, 부장]박부장&lt;ppp@ldb.com&gt;</option>
                    <option value="emp003">[인사팀, 대리]이대리&lt;eee@ldb.com&gt;</option>
                    <option value="emp004">[고객지원팀, 과장]홍과장&lt;hhh@ldb.com&gt;</option>
                </select>
            </div>
        </div>

        <!-- 참조자 -->
        <div class="mb-3 select-wrapper">
            <label class="form-label">참조자</label>
            <select class="form-select bg-glass employee-select" id="referrerSelect">
                <option value="">직원을 선택하세요</option>
                <option value='{"id":"emp001","dept":"웹개발팀","role":"사원","name":"김사원","email":"ttt@ldb.com"}'>[웹개발팀, 사원]김사원&lt;ttt@ldb.com&gt;</option>
                <option value='{"id":"emp002","dept":"운영팀","role":"부장","name":"박부장","email":"ppp@ldb.com"}'>[운영팀, 부장]박부장&lt;ppp@ldb.com&gt;</option>
                <option value='{"id":"emp003","dept":"인사팀","role":"대리","name":"이대리","email":"eee@ldb.com"}'>[인사팀, 대리]이대리&lt;eee@ldb.com&gt;</option>
                <option value='{"id":"emp004","dept":"고객지원팀","role":"과장","name":"홍과장","email":"hhh@ldb.com"}'>[고객지원팀, 과장]홍과장&lt;hhh@ldb.com&gt;</option>
            </select>
        </div>
        <div class="mb-3">
            <input type="text" id="referrerDisplay" class="form-control bg-glass" placeholder="선택된 참조자" readonly>
            <input type="hidden" name="referrers" id="referrersHidden">
        </div>

        <!-- 마감기한 -->
        <div class="mb-3">
            <label class="form-label">문서종료일 *</label>
            <input type="date" class="form-control bg-glass" name="deadline" required>
        </div>

        <!-- 양식별 폼들 -->
        <div id="휴가신청서" class="form-template d-none">
            <h5>휴가신청서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>휴가 유형</th>
                    <td>
                        <select name="leaveType" class="form-select bg-glass">
                            <option>연차</option>
                            <option>반차</option>
                            <option>경조사</option>
                            <option>병가</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>휴가 기간</th>
                    <td>
                        <input type="date" name="leaveStart" class="bg-glass"> ~
                        <input type="date" name="leaveEnd" class="bg-glass">
                    </td>
                </tr>
                <tr>
                    <th>잔여 연차</th>
                    <td>9일</td>
                </tr>
            </table>
        </div>

        <div id="지출결의서" class="form-template d-none">
            <h5>지출결의서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>지출 항목</th>
                    <td><input type="text" name="expenseItem" class="form-control bg-glass"></td>
                </tr>
                <tr>
                    <th>금액</th>
                    <td><input type="number" name="amount" class="form-control bg-glass"></td>
                </tr>
                <tr>
                    <th>사용일자</th>
                    <td><input type="date" name="usedDate" class="form-control bg-glass"></td>
                </tr>
            </table>
        </div>

        <div id="프로젝트제안서" class="form-template d-none">
            <h5>프로젝트 제안서 양식</h5>
            <table class="table table-bordered bg-glass">
                <tr>
                    <th>프로젝트명</th>
                    <td><input type="text" name="projectTitle" class="form-control bg-glass"></td>
                </tr>
                <tr>
                    <th>예상 기간</th>
                    <td><input type="text" name="expectedDuration" class="form-control bg-glass" placeholder="예: 2025.01 ~ 2025.06"></td>
                </tr>
                <tr>
                    <th>목표</th>
                    <td><textarea name="projectGoal" class="form-control bg-glass" rows="3"></textarea></td>
                </tr>
            </table>
        </div>

        <!-- 제목 & 내용 -->
        <div class="mb-3">
            <label class="form-label">제목 *</label>
            <input type="text" class="form-control bg-glass" name="title" required>
        </div>
        <div class="mb-3">
            <label class="form-label">내용 *</label>
            <textarea class="form-control bg-glass" name="content" rows="5" required></textarea>
        </div>

        <!-- 첨부파일 -->
        <div class="mb-3">
            <label class="form-label">첨부파일 (최대 50MB)</label>
            <input type="file" class="form-control bg-glass" name="attachment">
        </div>

        <!-- 제출 -->
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
        $('.employee-select').select2({
            placeholder: '직원 검색...',
            allowClear: true
        });

        $('#referrerSelect').on('change', function () {
            const raw = $(this).val();
            if (!raw) return;

            const emp = JSON.parse(raw);
            const formatted = "[" + emp.dept + ", " + emp.role + "]" + emp.name + "<" + emp.email + ">";

            const display = $('#referrerDisplay');
            const hidden = $('#referrersHidden');

            if (hidden.val().includes(emp.id)) return;

            display.val(display.val() ? display.val() + ', ' + formatted : formatted);
            hidden.val(hidden.val() ? hidden.val() + ',' + emp.id : emp.id);
        });
    });

    function showFormTemplate() {
        const selected = document.getElementById("formTypeSelect").value;
        const templates = document.querySelectorAll(".form-template");
        templates.forEach(t => t.classList.add("d-none"));

        if (selected) {
            document.getElementById(selected).classList.remove("d-none");
        }
    }
</script>

</body>
</html>
