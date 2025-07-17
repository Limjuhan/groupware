<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>캘린더 조회 - LDBSOFT 그룹웨어</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.css" rel="stylesheet">
  <style>
    body { background-color: #f4f6f9; }
    .container { max-width: 1000px; margin-top: 40px; }
    #calendar {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.05);
    }
  </style>
</head>
<body>

<div class="container">
  <h2 class="mb-4">📅 캘린더 조회</h2>
  <div id="calendar"></div>
</div>

<!-- 일정 보기 모달 -->
<div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form>
        <div class="modal-header">
          <h5 class="modal-title">일정 정보</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="eventId" readonly>
          <div class="mb-3">
            <label for="eventTitle" class="form-label">제목</label>
            <input type="text" class="form-control" id="eventTitle" readonly>
          </div>
          <div class="mb-3">
            <label for="eventContent" class="form-label">내용</label>
            <textarea class="form-control" id="eventContent" rows="3" readonly></textarea>
          </div>
          <div class="mb-3">
            <label for="eventStart" class="form-label">시작일</label>
            <input type="date" class="form-control" id="eventStart" readonly>
          </div>
          <div class="mb-3">
            <label for="eventEnd" class="form-label">종료일</label>
            <input type="date" class="form-control" id="eventEnd" readonly>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');

    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      locale: 'ko',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: ''
      },
      events: [
        {
          id: '1',
          title: '프로젝트 A 시작',
          start: '2025-07-10',
          end: '2025-07-15',
          color: '#0d6efd',
          extendedProps: {
            content: '프로젝트 A를 본격적으로 시작합니다.'
          }
        },
        {
          id: '2',
          title: '전체 회의',
          start: '2025-07-12',
          color: '#20c997',
          extendedProps: {
            content: '부서 전체 회의가 진행됩니다.'
          }
        }
      ],
      eventClick: function(info) {
        const event = info.event;
        document.getElementById('eventId').value = event.id;
        document.getElementById('eventTitle').value = event.title;
        document.getElementById('eventContent').value = event.extendedProps.content || '';
        document.getElementById('eventStart').value = event.startStr;
        document.getElementById('eventEnd').value = event.endStr || '';

        var modal = new bootstrap.Modal(document.getElementById('eventModal'));
        modal.show();
      }
    });

    calendar.render();
  });
</script>
</body>
</html>
