package ldb.groupware.mapper.mybatis.alarm;

import ldb.groupware.domain.Alarm;
import ldb.groupware.dto.alarm.AlarmDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AlarmMapper {
    int updateAlarmByDocId(@Param("docId") Integer docId,
                           @Param("memId") String memId,
                           @Param("status") Integer status);


    int insertAlarm(Alarm alarm);

    int markAsRead(AlarmDto dto);
}
