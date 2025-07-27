package ldb.groupware.mapper.mybatis.calendar;

import ldb.groupware.dto.calendar.ScheduleListDto;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CalendarMapper {
    List<ScheduleListDto> selectScheduleList(PaginationDto pageDto);
    int countScheduleList();
}