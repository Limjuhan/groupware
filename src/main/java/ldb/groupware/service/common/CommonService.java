package ldb.groupware.service.common;

import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.mapper.mybatis.common.CommonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Slf4j
@Service
public class CommonService {

    CommonMapper commonMapper;

    public CommonService(CommonMapper commonMapper) {
        this.commonMapper = commonMapper;
    }

    public List<CommonTypeDto> getCommonTypesByGroup(String codeGroup) {
        return commonMapper.selectCommonTypesByGroup(codeGroup);
    }

    public List<DeptDto> getDeptList() {
        List<DeptDto> deptList = commonMapper.getDeptList();

        if (deptList == null || deptList.isEmpty()) {
            throw new NoSuchElementException("조회된 부서가 없습니다.");
        }
        return deptList;
    }
}
