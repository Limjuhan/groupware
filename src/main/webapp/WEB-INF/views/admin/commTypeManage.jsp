<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>공통코드 사용여부 관리</title>
    <style>
        /* 공통 컨텐츠 영역 */
        .page-content {
            width: 100%;
            min-height: calc(100vh - 160px);
            display: flex;
            flex-direction: column;
            background-color: #fff;
            padding: 20px;
            box-sizing: border-box;
        }

        .page-content table {
            table-layout: fixed;
            word-break: break-word;
        }

        .page-title {
            margin-bottom: 20px;
            font-weight: bold;
        }

        /* 기존 페이지 스타일 */
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .group-title {
            font-size: 1.25rem;
            font-weight: bold;
            margin-top: 40px;
            margin-bottom: 10px;
        }
        .text-end {
            margin-top: 40px;
            padding-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="page-content">
    <h2 class="fw-bold">⚙️ 공통코드 사용여부 관리</h2>
    <div id="codeContainer"></div>

    <div class="text-end mt-4">
        <button id="saveBtn" class="btn btn-success">✅ 변경사항 저장</button>
    </div>
</div>

<script>
    $(document).ready(function () {
        loadCodes();

        // 공통코드 목록 불러오기
        function loadCodes() {
            $.getJSON("/common/list", function (res) {
                if (!res.success) {
                    alert(res.message || "코드 목록을 불러오는데 실패했습니다.");
                    return;
                }
                renderTable(res.data);
                console.log('공통코드목록', res.data);
            });
        }

        // 테이블 렌더링
        function renderTable(data) {
            $("#codeContainer").empty();
            $.each(data, function (groupKey, groupData) {
                var groupName = groupData.groupName;
                var codes = groupData.codes;

                var html = '';
                html += '<div class="group-title">' + groupName + '(' + groupKey + ')</div>';
                html += '<table class="table table-bordered">';
                html += '<thead class="table-light">';
                html += '<tr><th>코드</th><th>설명</th><th>사용여부</th></tr>';
                html += '</thead>';
                html += '<tbody>';
                $.each(codes, function (i, code) {
                    html += '<tr>';
                    html += '<td>' + code.codeId + '</td>';
                    html += '<td>' + code.codeName + '</td>';
                    html += '<td>';
                    html += '<input type="radio" name="' + groupKey + '_' + code.codeId + '" value="Y" ' + (code.useYn === 'Y' ? 'checked' : '') + '> Y ';
                    html += '<input type="radio" name="' + groupKey + '_' + code.codeId + '" value="N" ' + (code.useYn === 'N' ? 'checked' : '') + '> N';
                    html += '</td>';
                    html += '</tr>';
                });
                html += '</tbody>';
                html += '</table>';
                $("#codeContainer").append(html);
            });
        }

        // 저장
        $("#saveBtn").click(function () {
            var updates = [];
            $("#codeContainer input[type=radio]:checked").each(function () {
                var parts = $(this).attr("name").split("_");
                var group = parts[0];
                var codeId = parts.slice(1).join("_");
                var useYn = $(this).val();
                updates.push(
                    {
                        codeGroup: group,
                        codeId: codeId,
                        useYn: useYn
                    }
                );
            });

            $.ajax({
                url: "/common/update-usage",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify(updates),
                success: function (res) {
                    if (res.success) {
                        alert("저장되었습니다.");
                        loadCodes();
                    } else {
                        alert(res.message || "저장 실패");
                    }
                },
                error: function () {
                    alert("서버 오류가 발생했습니다.");
                }
            });
        });
    });
</script>
</body>
</html>