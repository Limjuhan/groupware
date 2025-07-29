package ldb.groupware.service.admin;

import ldb.groupware.dto.admin.MenuDto;
import ldb.groupware.dto.admin.MenuFormDto;
import ldb.groupware.mapper.mybatis.admin.AdminMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class AdminService {

    private final AdminMapper adminMapper;

    public AdminService(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    // 전체 메뉴 목록 불러오기
    public List<MenuDto> getMenuList() {
        return adminMapper.selectMunuList();
    }

    // 부서 선택 시 권한 불러오기
    public List<String> getMenuAuthority(String deptId) {
        return adminMapper.selectMenuAuthority(deptId);
    }

    public void updateAuth(String deptId, List<String> menuList) {
        adminMapper.deleteAuth(deptId);
        if (menuList != null && !menuList.isEmpty()) {
            for (String menu : menuList) {
                adminMapper.insertAuth(deptId, menu);
            }
        }
    }

    // 메뉴 등록
    public boolean insertMenu(MenuFormDto dto) {
        String next = adminMapper.nextMenuCode();
        String MenuCode = "A_" + next;
        dto.setMenuCode(MenuCode);
        adminMapper.insertMenu(dto);
        return true;
    }
}
