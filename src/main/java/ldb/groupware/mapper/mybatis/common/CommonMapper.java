package ldb.groupware.mapper.mybatis.common;

import ldb.groupware.dto.common.CommonCodeDto;
import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.common.DeptDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommonMapper {
    List<CommonTypeDto> selectCommonTypesByGroup(String codeGroup);

    List<DeptDto> getDeptList();

    List<CommonCodeDto> selectAllCodes();

    void updateCodeUsage(CommonCodeDto dto);
}
