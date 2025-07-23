package ldb.groupware.service.member;

import ldb.groupware.dto.member.MemberAnnualLeaveDto;
import ldb.groupware.dto.member.MemberAnnualLeaveHistoryDto;
import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.member.*;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
public class MemberService {

    private final MemberMapper memberMapper;

    public MemberService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    // 개인정보 조회용
    public MemberUpdateDto getInfo(String memId) {
        return memberMapper.selectInfo(memId);
    }

    // 사원관리 List 조회용
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

    // 부서이름 조회용
    public List<DeptDto> getDeptList() {
        return memberMapper.getDeptList();
    }

    // 직급 이름 조회용
    public List<RankDto> getRankList() {
        return memberMapper.getRankList();
    }

    // 사원등록
    public boolean insertMember(MemberFormDto dto, MultipartFile file) {
        AttachmentDto attach = new AttachmentDto();
        // 1. 입사년도 추출
        String year = String.valueOf(dto.getMemHiredate().getYear());

        // 2. 해당 입사년도 기준 다음 일련번호 조회 (4자리)
        String seq = memberMapper.nextMemId(year);

        // 3. 사번 생성 (입사년도 + 4자리 일련번호)
        String memId = "LDB" + year + seq;

        // 4. 회사 이메일 생성
        String memEmail = memId + "@ldb.com";

        // 5. 기본 비밀번호 (추후 암호화)
        String memPass = "1234";

        // 6. 주민번호 뒷자리 (추후 암호화)
        String juminBack = dto.getJuminBack();

        // 7. DB 저장용 맵 구성
        Map<String, Object> map = new HashMap<>();
        map.put("memId", memId);
        map.put("memPass", memPass);
        map.put("memEmail", memEmail);
        map.put("memPrivateEmail", dto.getMemPrivateEmail());
        map.put("memName", dto.getMemName());
        map.put("memGender", dto.getMemGender());
        map.put("memPhone", dto.getMemPhone());
        map.put("juminFront", dto.getJuminFront());
        map.put("juminBack", juminBack);
        map.put("memAddress", dto.getMemAddress());
        map.put("memStatus", dto.getMemStatus());
        map.put("memHiredate", dto.getMemHiredate());
        map.put("deptId", dto.getDeptId());
        map.put("rankId", dto.getRankId());
        map.put("createdBy", "admin");
        map.put("createdAt", LocalDateTime.now());
        memberMapper.insertMember(map);
        if (file != null && !file.isEmpty()) {
            String uploadDir = System.getProperty("user.dir") + "/upload/profile/";
            String savedName = uploadFileCreate(file, uploadDir);
            if (savedName != null) {
                attach.setAttachType("P");
                attach.setSavedName(savedName);
                attach.setFilePath("/P/");
                attach.setOriginalName(file.getOriginalFilename());
                attach.setBusinessId(memId);
                memberMapper.insertAttach(attach);
            } else {
                log.error("File upload failed for: {}", file.getOriginalFilename());
                return false;
            }
        }
        return true;
    }

    // 사원설정 (부서,직급)
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(String memId, String deptId, String rankId) {

        int updated = memberMapper.updateMemberByMng(memId, deptId, rankId);

        if (updated <= 0) {
            return ApiResponseDto.fail("사원 정보 수정 실패");
        }

        UpdateMemberDto dto = new UpdateMemberDto(memId, deptId, rankId);
        return ApiResponseDto.ok(dto, "사원 정보 수정 완료");
    }

    // 첨부파일 이미지 저장
    private String uploadFileCreate(MultipartFile file, String path) {
        String name = file.getOriginalFilename();
        String extension = name.substring(name.lastIndexOf("."));
        String orgFile = UUID.randomUUID().toString() + extension;
        File f = new File(path);
        if (!f.exists()) {
            f.mkdirs();
        }
        try {
            file.transferTo(new File(path + orgFile));
            return orgFile;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 개인 정보 수정
    public boolean updateInfo(MemberUpdateDto dto) {
        return memberMapper.updateInfo(dto) > 0;
    }

    // 연차 정보 조회
    public MemberAnnualLeaveDto getAnnualInfo(String memId) {
        return memberMapper.selectAnnualByMemId(memId);
    }

    // 연차 사용 내역 조회
    public List<MemberAnnualLeaveHistoryDto> getAnnualLeaveHistory(String memId) {
        return memberMapper.selectAnnualLeaveHistory(memId);
    }
}
