package ldb.groupware.service.common;

import ldb.groupware.dto.common.CommonCodeDto;
import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.mapper.mybatis.common.CommonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.*;

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

    public Map<String, List<CommonCodeDto>> getGroupedCodes() {
        List<CommonCodeDto> allCodes =  commonMapper.selectAllCodes();
        Map<String, List<CommonCodeDto>> groupedMap = new LinkedHashMap<>();

        for (CommonCodeDto code : allCodes) {
            String codeGroup = code.getCodeGroup();
            if (!groupedMap.containsKey(codeGroup)) {
                groupedMap.put(codeGroup, new ArrayList<CommonCodeDto>());
            }
            groupedMap.get(codeGroup).add(code);
        }

        return groupedMap;
    }

    public void updateCodeUsage(List<CommonCodeDto> codes) {
        if (codes == null || codes.isEmpty()) {
            throw new IllegalArgumentException("코드정보가 존재하지않습니다.");
        }
        for (CommonCodeDto dto : codes) {
            commonMapper.updateCodeUsage(dto);
        }
    }
}
