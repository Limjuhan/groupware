package ldb.groupware.mapper.mybatis.menu;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MenuAuthorityMapper {
    List<String> selectAllowedMenus(@Param("deptId") String deptId,@Param("rankId") String rankId);
}
