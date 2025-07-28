package ldb.groupware.mapper.mybatis.calendar;

import ldb.groupware.dto.calendar.EventDto;
import ldb.groupware.dto.calendar.ScheduleEditFormDto;
import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface CalendarMapper {
    List<ScheduleListDto> selectScheduleList(PaginationDto pageDto);

    int countScheduleList(PaginationDto pDto);

    void insertCalendar(Map<String, Object> map);

    int deleteCalendar(@Param("scheduleId") Integer scheduleId);

    ScheduleEditFormDto selectCalendar(@Param("scheduleId") Integer scheduleId);

    void updateCalendar(ScheduleEditFormDto dto);

    List<EventDto> selectAllScheduleList();
}