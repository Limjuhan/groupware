package ldb.groupware.mapper.mybatis.admin;

import ldb.groupware.dto.admin.DashboardInfoDto;
import ldb.groupware.dto.admin.MenuDto;
import ldb.groupware.dto.admin.MenuFormDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {

    List<MenuDto> selectMunuList();

    List<String> selectMenuAuthority(@Param("deptId") String deptId);

    void deleteAuth(@Param("deptId") String deptId);

    void insertAuth(@Param("deptId") String deptId, @Param("menu") String menu);

    String nextMenuCode();

    void insertMenu(MenuFormDto dto);

    List<DashboardInfoDto> getAnnualLeaveUsage(@Param("year") Integer year,
                                               @Param("deptId") String deptId,
                                               @Param("startNum") Integer startNum,
                                               @Param("itemsPerPage") Integer itemsPerPage);

    int countAnnualLeaveUsage(@Param("year") Integer year,
                              @Param("deptId") String deptId);
}
