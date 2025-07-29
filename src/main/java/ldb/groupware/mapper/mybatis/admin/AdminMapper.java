package ldb.groupware.mapper.mybatis.admin;

import ldb.groupware.dto.admin.MenuDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {

    List<MenuDto> selectMunuList();

    List<String> selectMenuAuthority(@Param("deptId") String deptId);

    void deleteAuth(@Param("deptId") String deptId);

    void insertAuth(@Param("deptId") String deptId, @Param("menu") String menu);
}
