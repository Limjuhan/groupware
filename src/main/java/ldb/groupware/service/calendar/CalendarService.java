package ldb.groupware.service.calendar;

import jakarta.servlet.http.HttpSession;
import ldb.groupware.dto.calendar.EventDto;
import ldb.groupware.dto.calendar.ScheduleEditFormDto;
import ldb.groupware.dto.calendar.ScheduleFormDto;
import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.calendar.CalendarMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class CalendarService {

    private final CalendarMapper calendarMapper;

    public CalendarService(CalendarMapper calendarMapper) {
        this.calendarMapper = calendarMapper;
    }

    // 일정목록 조회
    public List<ScheduleListDto> getScheduleList(PaginationDto pageDto) {
        return calendarMapper.selectScheduleList(pageDto);
    }

    // 페이지 처리를 위한 갯수
    public int getTotalCount(String searchType, String keyword) {
        PaginationDto p = new PaginationDto();
        p.setSearchType(searchType);
        p.setKeyword(keyword);
        return calendarMapper.countScheduleList(p);
    }


    // 일정등록
    public void insertCalendar(ScheduleFormDto dto, String loginId) {
        dto.setCreatedBy(loginId);
        calendarMapper.insertCalendar(dto);
    }

    // 일정 삭제
    public int deleteCalender(Integer scheduleId) {
        return calendarMapper.deleteCalendar(scheduleId);
    }
    
    // 일정 조회(수정페이지)
    public ScheduleEditFormDto getScheduleForEdit(Integer scheduleId) {
        ScheduleEditFormDto dto = calendarMapper.selectCalendar(scheduleId);
        if (dto == null) {
            return null;
        }
        return dto;
    }

    // 일정 수정
    public boolean updateCalendar(ScheduleEditFormDto dto,String loginId) {
        dto.setUpdatedBy(loginId);
        calendarMapper.updateCalendar(dto);
        return true;
    }

    // 캘린더 들어갈 정보
    public List<EventDto> getEventList() {
        return calendarMapper.selectAllScheduleList();
    }

    // 메인화면 목록 조회
    public List<ScheduleListDto> getRecentSchedules() {
        return calendarMapper.selectRecentSchedules();
    }
}
