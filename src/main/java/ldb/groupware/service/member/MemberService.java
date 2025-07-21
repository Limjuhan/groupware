package ldb.groupware.service.member;

import ldb.groupware.dto.common.AttachmentDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.common.PaginationDto;
import ldb.groupware.dto.member.*;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;

    // 개인정보 조회용
    public MemberInfoDto getInfo(String memId) {
        return memberMapper.selectInfo(memId);
    }

    // 개인정보 수정 처리
    public boolean updateInfo(String memId, MemberUpdateDto dto, MultipartFile photo) {
        MemberInfoDto existing = memberMapper.selectInfo(memId);

        String phone = isBlank(dto.getPhone()) ? existing.getMemPhone() : dto.getPhone();
        String privateEmail = isBlank(dto.getPrivateEmail()) ? existing.getMemPrivateEmail() : dto.getPrivateEmail();
        String address = isBlank(dto.getAddress()) ? existing.getMemAddress() : dto.getAddress();

        boolean result = memberMapper.updateInfo(memId, phone, privateEmail, address) > 0;

        if (photo != null && !photo.isEmpty()) {
            result = result && updatePhoto(memId, photo);
        }

        return result;
    }

    private boolean updatePhoto(String memId, MultipartFile photo) {
        try {
            memberMapper.deletePhoto(memId);

            String saveDir = "/upload/profile";
            File dir = new File(saveDir);
            if (!dir.exists()) dir.mkdirs();

            String originalName = photo.getOriginalFilename();
            String savedName = UUID.randomUUID() + "_" + originalName;
            File target = new File(saveDir, savedName);
            photo.transferTo(target);

            AttachmentDto attach = new AttachmentDto();
            attach.setBusinessId(memId);
            attach.setAttachType("P");
            attach.setOriginalName(originalName);
            attach.setSavedName(savedName);
            attach.setFilePath(saveDir);
            attach.setCreatedAt(LocalDateTime.now());

            memberMapper.insertPhoto(attach);
            return true;

        } catch (IOException e) {
            log.error("프로필 사진 저장 실패", e);
            return false;
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    public Map<String, Object> getMembers(PaginationDto paginationDto, String dept, String rank, String name) {
        if (paginationDto.getPage() <= 0) paginationDto.setPage(1);

        int totalCount = memberMapper.countMembers(dept, rank, name);
        paginationDto.setTotalRows(totalCount);
        paginationDto.calculatePagination();

        List<MemberListDto> list = memberMapper.getPagedMembers(
                dept, rank, name,
                paginationDto.getStartNum(),
                paginationDto.getItemsPerPage()
        );

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("pagination", paginationDto);

        return map;
    }

    public List<DeptDto> getDeptList() {
        return memberMapper.getDeptList();
    }

    public List<RankDto> getRankList() {
        return memberMapper.getRankList();
    }
}
