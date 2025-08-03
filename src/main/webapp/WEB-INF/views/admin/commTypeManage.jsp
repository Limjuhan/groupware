<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공통코드 사용여부 관리</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1100px; margin-top: 40px; }
    .table th, .table td { vertical-align: middle; text-align: center; }
    .group-title { font-size: 1.25rem; font-weight: bold; margin-top: 40px; margin-bottom: 10px; }
  </style>
</head>
<body>
<div class="container bg-white p-4 shadow rounded">
  <h2 class="mb-4 fw-bold">⚙️ 공통코드 사용여부 관리</h2>
  <div id="codeContainer"></div>

  <!-- 저장 버튼 -->
  <div class="text-end mt-4">
    <button id="saveBtn" class="btn btn-success">✅ 변경사항 저장</button>
  </div>
</div>

<script>
  $(document).ready(function(){
    loadCodes();

    // 공통코드 목록 불러오기
    function loadCodes(){
      $.getJSON("/common/list", function(res){
        if(!res.success) {
          alert(res.message || "코드 목록을 불러오는데 실패했습니다.");
          return;
        }
        renderTable(res.data);
        console.log('공통코드목록', res.data);
      });
    }

    // 테이블 렌더링
    function renderTable(data){
      $("#codeContainer").empty();
      $.each(data, function(group, codes){
        var html = '';
        html += '<div class="group-title">' + group + '</div>';
        html += '<table class="table table-bordered">';
        html += '<thead class="table-light">';
        html += '<tr><th>코드</th><th>설명</th><th>사용여부</th></tr>';
        html += '</thead>';
        html += '<tbody>';
        $.each(codes, function(i, code){
          html += '<tr>';
          html += '<td>' + code.codeId + '</td>';
          html += '<td>' + code.codeName + '</td>';
          html += '<td>';
          html += '<input type="radio" name="' + group + '_' + code.codeId + '" value="Y" ' + (code.useYn === 'Y' ? 'checked' : '') + '> Y ';
          html += '<input type="radio" name="' + group + '_' + code.codeId + '" value="N" ' + (code.useYn === 'N' ? 'checked' : '') + '> N';
          html += '</td>';
          html += '</tr>';
        });
        html += '</tbody>';
        html += '</table>';
        $("#codeContainer").append(html);
      });
    }

    // 저장
    $("#saveBtn").click(function(){
      var updates = [];
      $("#codeContainer input[type=radio]:checked").each(function(){
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
        success: function(res){
          if(res.success) {
            alert("저장되었습니다.");
            loadCodes();
          } else {
            alert(res.message || "저장 실패");
          }
        },
        error: function(){
          alert("서버 오류가 발생했습니다.");
        }
      });
    });
  });
</script>
</body>
</html>
