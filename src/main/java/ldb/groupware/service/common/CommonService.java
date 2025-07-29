package ldb.groupware.service.common;

import ldb.groupware.dto.common.CommonTypeDto;
import ldb.groupware.mapper.mybatis.common.CommonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

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
}
