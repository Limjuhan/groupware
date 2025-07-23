package ldb.groupware.service.member;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.member.*;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.util.CipherUtil;
import lombok.extern.slf4j.Slf4j;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class MemberService {

    private final MemberMapper memberMapper;
    private final AttachmentService attachmentService;
    private final CipherUtil cipherUtil;

    public MemberService(MemberMapper memberMapper, AttachmentService attachmentService, CipherUtil cipherUtil) {
        this.memberMapper = memberMapper;
        this.attachmentService = attachmentService;
        this.cipherUtil = cipherUtil;
    }

    public MemberUpdateDto getInfo(String memId) {
        MemberUpdateDto dto = memberMapper.selectInfo(memId);
        if (dto != null && dto.getJuminBack() != null) {
            try {
                dto.setJuminBack(cipherUtil.decrypt(dto.getJuminBack(), memId)); // 복호화
            } catch (Exception e) {
                log.error("Failed to decrypt jumin_back for memId: {}", memId, e);
            }
        }
        return dto;
    }

    public List<MemberAnnualLeaveHistoryDto> getAnnualLeaveHistory(String memId) {
        return memberMapper.selectAnnualLeaveHistory(memId);
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

    public boolean insertMember(MemberFormDto dto, MultipartFile file) {
        String year = String.valueOf(dto.getMemHiredate().getYear());
        String seq = memberMapper.nextMemId(year);
        String memId = "LDB" + year + seq;
        String memEmail = memId + "@ldb.com";
        String memPass = BCrypt.hashpw("1234", BCrypt.gensalt()); // 비밀번호 해싱
        String juminBack = cipherUtil.encrypt(dto.getJuminBack(), memId); // 주민번호 뒷자리 암호화

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
            try {
                attachmentService.saveAttachments(memId, "P", List.of(file));
            } catch (RuntimeException e) {
                log.error("File upload failed for: {}", file.getOriginalFilename(), e);
                return false;
            }
        }

        return true;
    }

    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(String memId, String deptId, String rankId) {
        int updated = memberMapper.updateMemberByMng(memId, deptId, rankId);
        if (updated <= 0) {
            return ApiResponseDto.fail("사원 정보 수정 실패");
        }
        UpdateMemberDto dto = new UpdateMemberDto(memId, deptId, rankId);
        return ApiResponseDto.ok(dto, "사원 정보 수정 완료");
    }

    public boolean updateInfo(MemberUpdateDto dto) {
        if (dto.getDeletePhoto() != null && !dto.getDeletePhoto().isEmpty()) {
            attachmentService.deleteAttachment(List.of(dto.getDeletePhoto()));
        }

        if (dto.getPhoto() != null && !dto.getPhoto().isEmpty()) {
            attachmentService.saveAttachments(dto.getMemId(), "P", List.of(dto.getPhoto()));
        }

        return memberMapper.updateInfo(dto) > 0;
    }

    public boolean verifyPassword(String memId, String rawPassword) {
        String pass = memberMapper.getPasswordByMemId(memId);
        if (pass == null) {
            return false;
        }
        return BCrypt.checkpw(rawPassword, pass);
    }

    public boolean updatePassword(String memId, String newPassword) {
        String hashPw = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        return memberMapper.updatePassword(memId, hashPw) > 0;
    }

    public MemberAnnualLeaveDto getAnnualInfo(String memId) {
        return memberMapper.selectAnnualByMemId(memId);
    }
}
