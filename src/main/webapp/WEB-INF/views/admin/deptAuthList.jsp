<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>부서별 메뉴 권한 설정 - LDBSOFT</title>
    <style>
        /* 리스트 아이템 스타일 */
        .list-group-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 1rem;
            border: none;
            border-bottom: 1px solid #e9ecef;
        }

        .list-group-item span {
            cursor: pointer;
            color: #0d6efd;
        }

        .list-group-item span:hover {
            color: #0a58ca;
        }

        /* 리스트 박스 스타일 */
        .list-box {
            min-height: 300px;
            max-height: 350px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            background-color: #fff;
        }

        /* 버튼 스타일 */
        .btn-move {
            width: 100%;
            margin-bottom: 0.5rem;
        }
    </style>
    <script>
        var menuListAll = [];
        var menuListDept = [];

        $(document).ready(function () {
            $.get("/admin/menuList", function (res) {
                menuListAll = res;
                drawMenuLists();
            });

            $("#deptSelect").on("change", function () {
                var deptId = $(this).val();
                if (deptId) {
                    $('#menuSection').removeClass('d-none');
                    $.get("/admin/menuAuthority", {deptId: deptId}, function (selectedCodes) {
                        menuListDept = selectedCodes;
                        drawMenuLists();
                    });
                } else {
                    $('#menuSection').addClass('d-none');
                    menuListDept = [];
                    drawMenuLists();
                }
            });
        });

        function drawMenuLists() {
            var allMenuList = $("#allMenuList").empty();
            var authMenuList = $("#authMenuList").empty();

            menuListAll.forEach(function (menu) {
                if (!menuListDept.includes(menu.menuCode)) {
                    allMenuList.append(
                        '<li class="list-group-item">' +
                        '<span onclick="toggleCheckbox(this)">' + menu.menuName + '</span>' +
                        '<input type="checkbox" value="' + menu.menuCode + '">' +
                        '</li>'
                    );
                }
            });

            menuListAll.forEach(function (menu) {
                if (menuListDept.includes(menu.menuCode)) {
                    authMenuList.append(
                        '<li class="list-group-item">' +
                        '<span onclick="toggleCheckbox(this)">' + menu.menuName + '</span>' +
                        '<input type="checkbox" value="' + menu.menuCode + '">' +
                        '</li>'
                    );
                }
            });
        }

        function toggleCheckbox(element) {
            var checkbox = $(element).siblings('input[type="checkbox"]');
            checkbox.prop('checked', !checkbox.prop('checked'));
        }

        function moveMenus(from, to) {
            var fromList = from === 'all' ? "#allMenuList" : "#authMenuList";
            var toList = to === 'all' ? "#allMenuList" : "#authMenuList";

            $(fromList + " input:checked").each(function () {
                var code = $(this).val();
                if (to === 'auth') {
                    menuListDept.push(code);
                } else {
                    menuListDept = menuListDept.filter(function (c) {
                        return c !== code;
                    });
                }
            });

            drawMenuLists();
        }

        function saveDeptMenuAuth() {
            var deptId = $("#deptSelect").val();
            if (!deptId) {
                alert("부서를 먼저 선택하세요.");
                return;
            }

            var menuListDept = [];
            $("#authMenuList input").each(function () {
                menuListDept.push($(this).val());
            });

            // jQuery $.ajax를 사용하여 데이터 전송
            $.ajax({
                url: "/admin/updateAuth?deptId=" + deptId,
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(menuListDept),
                dataType: "json",
                success: function (response) {
                    alert(response.message);
                },
                error: function (xhr, status, error) {
                    console.error("권한 저장 중 오류 발생:", error);
                    alert("권한 저장에 실패했습니다.");
                }
            });
        }
    </script>
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="card shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">부서별 메뉴 권한 설정</h2>
            <a href="/admin/getMenuForm" class="btn btn-primary">등록</a>
        </div>

        <div class="mb-4">
            <label for="deptSelect" class="form-label fw-medium">부서 선택 <span class="text-danger">*</span></label>
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
                    <h6 class="fw-medium">전체 메뉴</h6>
                    <ul id="allMenuList" class="list-group list-box"></ul>
                </div>

                <div class="col-md-2 d-flex align-items-center justify-content-center">
                    <div>
                        <button type="button" class="btn btn-outline-primary btn-move"
                                onclick="moveMenus('all','auth')">➡
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-move"
                                onclick="moveMenus('auth','all')">⬅
                        </button>
                    </div>
                </div>

                <!-- 부서 권한 목록 -->
                <div class="col-md-5">
                    <h6 class="fw-medium">부서 권한</h6>
                    <ul id="authMenuList" class="list-group list-box"></ul>
                </div>
            </div>

            <!-- 저장 버튼 -->
            <div class="text-end mt-4">
                <button type="button" class="btn btn-primary px-4" onclick="saveDeptMenuAuth()">저장</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>