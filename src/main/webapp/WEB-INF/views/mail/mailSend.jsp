<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>메일 보내기 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 900px; margin-top: 40px; }
    .form-label.required::after { content: " *"; color: red; }
    .star { cursor: pointer; font-size: 1.2em; color: #ccc; }
    .star.favorited { color: gold; }
  </style>
</head>
<body>

<div class="container bg-white p-4 shadow rounded">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>메일 보내기</h2>
    <button class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addressBookModal">📇 주소록</button>
  </div>

  <form method="post" action="mailSendAction.jsp" enctype="multipart/form-data">
    <div class="mb-3">
      <label class="form-label required">수신자 이메일</label>
      <input type="text" name="receiver" id="receiverInput" class="form-control" placeholder="예: kim@ldbsoft.co.kr, park@ldbsoft.co.kr" required />
    </div>

    <div class="mb-3">
      <label class="form-label required">제목</label>
      <input type="text" name="subject" class="form-control" required />
    </div>

    <div class="mb-3">
      <label class="form-label required">내용</label>
      <textarea name="content" class="form-control" rows="8" required></textarea>
    </div>

    <div class="mb-3">
      <label class="form-label">첨부파일 (최대 50MB)</label>
      <input type="file" name="attachment" class="form-control" />
    </div>

    <div class="d-flex justify-content-between">
      <a href="mailList.jsp" class="btn btn-secondary">취소</a>
      <button type="submit" class="btn btn-primary">메일 보내기</button>
    </div>
  </form>
</div>

<!-- 주소록 모달 -->
<div class="modal fade" id="addressBookModal" tabindex="-1" aria-labelledby="addressBookModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">주소록</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- 탭 -->
        <ul class="nav nav-tabs mb-3" id="addressTabs" role="tablist">
          <li class="nav-item">
            <button class="nav-link active" id="tab-all" data-bs-toggle="tab" data-bs-target="#allList" type="button" role="tab">전체 사원</button>
          </li>
          <li class="nav-item">
            <button class="nav-link" id="tab-vip" data-bs-toggle="tab" data-bs-target="#vipList" type="button" role="tab">⭐ 즐겨찾기</button>
          </li>
        </ul>

        <!-- 탭 콘텐츠 -->
        <div class="tab-content">
          <!-- 전체 사원 탭 -->
          <div class="tab-pane fade show active" id="allList" role="tabpanel">
            <table class="table table-hover table-sm">
              <thead><tr><th></th><th>이름</th><th>직급</th><th>이메일</th><th>★</th></tr></thead>
              <tbody id="fullList">
                <!-- 사원 데이터 하드코딩 -->
                <tr>
                  <td><input type="checkbox" class="email-checkbox" value="kim@ldbsoft.co.kr" onchange="updateReceivers()"></td>
                  <td>김이사</td><td>이사</td><td>kim@ldbsoft.co.kr</td>
                  <td><span class="star" onclick="toggleStar(event, this)">★</span></td>
                </tr>
                <tr>
                  <td><input type="checkbox" class="email-checkbox" value="park@ldbsoft.co.kr" onchange="updateReceivers()"></td>
                  <td>박부장</td><td>부장</td><td>park@ldbsoft.co.kr</td>
                  <td><span class="star favorited" onclick="toggleStar(event, this)">★</span></td>
                </tr>
                <tr>
                  <td><input type="checkbox" class="email-checkbox" value="lee@ldbsoft.co.kr" onchange="updateReceivers()"></td>
                  <td>이대리</td><td>대리</td><td>lee@ldbsoft.co.kr</td>
                  <td><span class="star" onclick="toggleStar(event, this)">★</span></td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- VIP 즐겨찾기 탭 -->
          <div class="tab-pane fade" id="vipList" role="tabpanel">
            <table class="table table-hover table-sm">
              <thead><tr><th></th><th>이름</th><th>직급</th><th>이메일</th><th>★</th></tr></thead>
              <tbody id="vipOnlyList">
                <!-- JS에서 복제됨 -->
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- JS 기능 -->
<script>
  function updateReceivers() {
    const checkboxes = document.querySelectorAll('.email-checkbox:checked');
    const emails = Array.from(checkboxes).map(cb => cb.value);
    document.getElementById('receiverInput').value = emails.join(', ');
  }

  function toggleStar(event, el) {
    event.stopPropagation();
    el.classList.toggle('favorited');
    refreshVipList();
  }

  function refreshVipList() {
    const vipTable = document.getElementById('vipOnlyList');
    vipTable.innerHTML = '';

    document.querySelectorAll('#fullList tr').forEach(row => {
      const star = row.querySelector('.star');
      if (star && star.classList.contains('favorited')) {
        const clone = row.cloneNode(true);

        // 이벤트 재연결
        const cb = clone.querySelector('.email-checkbox');
        cb.onchange = updateReceivers;

        const newStar = clone.querySelector('.star');
        newStar.onclick = (e) => toggleStar(e, newStar);

        vipTable.appendChild(clone);
      }
    });
  }

  window.addEventListener('load', refreshVipList);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
