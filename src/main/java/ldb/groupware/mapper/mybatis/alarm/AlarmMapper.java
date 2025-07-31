package ldb.groupware.mapper.mybatis.alarm;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AlarmMapper {
    int updateAlarmByDocId(@Param("docId") Integer docId,
                           @Param("memId") String memId,
                           @Param("status") Integer status);
}
