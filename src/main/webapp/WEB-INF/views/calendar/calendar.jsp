<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>캘린더 - LDBSOFT Groupware</title>
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .container {
            max-width: 1000px;
            margin-top: 40px;
        }
        #calendar {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        .fc-daygrid-event .fc-event-time {
            display: inline;
        }
        .fc-daygrid-event .fc-event-title {
            display: block;
            margin-top: 2px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="mb-4">📅 캘린더 조회</h2>
    <div id="calendar"></div>
</div>

<!-- 일정 모달 -->
<div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form>
                <div class="modal-header">
                    <h5 class="modal-title">일정 정보</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                        <input type="datetime-local" class="form-control" id="eventStart" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="eventEnd" class="form-label">종료일</label>
                        <input type="datetime-local" class="form-control" id="eventEnd" readonly>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('calendar');

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            buttonText: {
                today: '오늘',
                month: '월간',
                week: '주간',
                day: '일간'
            },
            eventTimeFormat: {
                hour: 'numeric',
                minute: '2-digit',
                meridiem: 'short'
            },
            events: {
                url: '/calendar/getScheduleList',
                method: 'GET',
                failure: function () {
                    alert('일정 데이터를 불러오지 못했습니다.');
                }
            },
            eventContent: function (arg) {
                const inner = document.createElement('div');

                // 시간 줄 + 줄바꿈 + 제목 줄
                const timeText = document.createElement('span');
                timeText.className = 'fc-event-time';
                timeText.innerText = arg.timeText;

                const titleText = document.createElement('div');
                titleText.className = 'fc-event-title';
                titleText.innerText = arg.event.title;

                inner.appendChild(timeText);
                inner.appendChild(titleText);

                return { domNodes: [inner] };
            },
            eventClick: function (info) {
                const event = info.event;
                const startStr = event.startStr?.substring(0, 16);
                const endStr = event.endStr?.substring(0, 16);

                document.getElementById('eventId').value = event.id;
                document.getElementById('eventTitle').value = event.title;
                document.getElementById('eventContent').value = event.extendedProps.content || '';
                document.getElementById('eventStart').value = startStr;
                document.getElementById('eventEnd').value = endStr;

                const modal = new bootstrap.Modal(document.getElementById('eventModal'));
                modal.show();
            }
        });

        calendar.render();
    });
</script>
</body>
</html>
