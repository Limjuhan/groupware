<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부서별 메뉴 권한 설정 - LDBSOFT</title>

    <!-- Bootstrap & Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <style>
        body {
            background-color: #1e1e1e;
            color: white;
        }
        .form-wrapper {
            max-width: 1000px;
            margin: 40px auto;
            background: rgba(255,255,255,0.05);
            padding: 30px;
            border-radius: 0.75rem;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .form-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 0.5rem;
        }
        .list-box {
            min-height: 300px;
            max-height: 350px;
            overflow-y: auto;
            background-color: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 0.5rem;
            padding: 0.5rem;
        }
        .list-group-item {
            background: transparent;
            color: white;
            border: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.4rem 0.8rem;
        }
        .btn-move {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            font-size: 0.85rem;
            border-radius: 0.25rem;
            padding: 0.25rem 0.6rem;
        }
        .btn-move:hover {
            background: rgba(255,255,255,0.1);
        }
        /* Select 스타일 */
        .form-select, select {
            background-color: rgba(255,255,255,0.05) !important;
            color: white !important;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 0.5rem;
        }
        .form-select option {
            background-color: #1e1e1e;
            color: white;
        }
        /* Select2 스타일 */
        .select2-container--default .select2-selection--single {
            background-color: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            height: 38px;
            display: flex;
            align-items: center;
            padding-left: 0.75rem;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: white !important;
        }
        .select2-container--default .select2-results > .select2-results__options {
            background-color: #1e1e1e !important;
            color: white !important;
        }
        .select2-results__option--highlighted.select2-results__option--selectable {
            background-color: #0d6efd !important;
            color: white !important;
        }
        #deptSelect {
            min-width: 300px;
        }
    </style>
</head>
<body>

<div class="form-wrapper shadow">
    <div class="d-flex justify-content-between align-items-center">
        <div class="form-title">🔐 부서별 메뉴 권한 설정</div>
        <a href="/admin/getMemberForm" class="btn btn-primary bg-glass">+ 등록</a>
    </div>

    <div class="mb-4">
        <label for="deptSelect" class="form-label">부서 선택 <span class="text-danger">*</span></label>
        <select id="deptSelect" class="form-select">
            <option value="" selected>부서를 선택하세요</option>
            <c:forEach var="dept" items="${deptList}">
                <option value="${dept.deptId}">${dept.deptName}</option>
            </c:forEach>
        </select>
    </div>

    <!-- 메뉴 영역 -->
    <div id="menuSection" class="d-none">
        <div class="row">
            <!-- 전체 메뉴 목록 -->
            <div class="col-md-5">
                <h6>전체 메뉴</h6>
                <ul id="allMenuList" class="list-group list-box"></ul>
            </div>

            <div class="col-md-2 d-flex align-items-center justify-content-center">
                <div>
                    <button type="button" class="btn btn-move mb-2" onclick="moveSelected('all','auth')">➡</button><br>
                    <button type="button" class="btn btn-move" onclick="moveSelected('auth','all')">⬅</button>
                </div>
            </div>

            <!-- 부서 권한 목록 -->
            <div class="col-md-5">
                <h6>부서 권한</h6>
                <ul id="authMenuList" class="list-group list-box"></ul>
            </div>
        </div>

        <!-- 저장 버튼 -->
        <div class="text-end mt-4">
            <button type="button" class="btn btn-primary px-4" onclick="savePermissions()">💾 저장</button>
        </div>
    </div>
</div>

<script>
    var allMenus = [];
    var deptMenus = [];

    $(document).ready(function() {
        $('#deptSelect').select2({
            placeholder: '부서를 선택하세요'
        });

        $.get("/admin/menuList", function(res) {
            allMenus = res;
            renderLists();
        });

        $("#deptSelect").on("change", function() {
            var deptId = $(this).val();
            if (deptId) {
                $('#menuSection').removeClass('d-none');
                $.get("/admin/menuAuthority", { deptId: deptId }, function(selectedCodes) {
                    deptMenus = selectedCodes;
                    renderLists();
                });
            } else {
                $('#menuSection').addClass('d-none');
                deptMenus = [];
                renderLists();
            }
        });
    });

    function renderLists() {
        var allMenuList = $("#allMenuList").empty();
        var authMenuList = $("#authMenuList").empty();

        allMenus.forEach(function(menu) {
            if (!deptMenus.includes(menu.menuCode)) {
                allMenuList.append(
                    '<li class="list-group-item">' +
                    '<span>' + menu.menuName + '</span>' +
                    '<input type="checkbox" value="' + menu.menuCode + '">' +
                    '</li>'
                );
            }
        });

        allMenus.forEach(function(menu) {
            if (deptMenus.includes(menu.menuCode)) {
                authMenuList.append(
                    '<li class="list-group-item">' +
                    '<span>' + menu.menuName + '</span>' +
                    '<input type="checkbox" value="' + menu.menuCode + '">' +
                    '</li>'
                );
            }
        });
    }

    function moveSelected(from, to) {
        var fromList = from === 'all' ? "#allMenuList" : "#authMenuList";
        var toList = to === 'all' ? "#allMenuList" : "#authMenuList";

        $(fromList + " input:checked").each(function() {
            var code = $(this).val();
            if (to === 'auth') {
                deptMenus.push(code);
            } else {
                deptMenus = deptMenus.filter(function(c) { return c !== code; });
            }
        });

        renderLists();
    }

    function savePermissions() {
        var deptId = $("#deptSelect").val();
        if (!deptId) {
            alert("부서를 먼저 선택하세요.");
            return;
        }

        fetch("/admin/updateAuth?deptId=" + deptId, {
            method: 'POST',
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(deptMenus)
        }).then(res => res.json())
            .then(res => alert(res.message));
    }
</script>
</body>
</html>