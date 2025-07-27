package ldb.groupware.service.calendar;

import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import ldb.groupware.mapper.mybatis.calendar.CalendarMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class CalendarService {

    private final CalendarMapper calendarMapper;

    public CalendarService(CalendarMapper calendarMapper) {
        this.calendarMapper = calendarMapper;
    }

    public List<ScheduleListDto> getScheduleList(PaginationDto pageDto) {
        return calendarMapper.selectScheduleList(pageDto);
    }

    public int getTotalCount() {
        return calendarMapper.countScheduleList();
    }
}
