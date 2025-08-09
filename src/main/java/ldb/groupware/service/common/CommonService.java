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

    public Map<String, Map<String, Object>> getGroupedCodes() {

        List<CommonCodeDto> allCodes =  commonMapper.selectAllCodes();
        Map<String, Map<String, Object>> resultMap = new LinkedHashMap<>();

        for (CommonCodeDto code : allCodes) {
            String group = code.getCodeGroup();

            resultMap.putIfAbsent(group, new LinkedHashMap<>());

            if (!resultMap.get(group).containsKey("groupName")) {
                resultMap.get(group).put("groupName", code.getCodeGroupName(group));
                resultMap.get(group).put("codes", new ArrayList<CommonCodeDto>());
            }

            List<CommonCodeDto> codeList = (List<CommonCodeDto>) resultMap.get(group).get("codes");
            codeList.add(code);
        }

        return resultMap;
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
