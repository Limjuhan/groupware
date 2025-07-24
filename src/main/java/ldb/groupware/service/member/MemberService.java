package ldb.groupware.service.member;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
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

    // 연차사용 내역 조회
    public List<MemberAnnualLeaveHistoryDto> getAnnualLeaveHistory(String memId) {
        return memberMapper.selectAnnualLeaveHistory(memId);
    }

    // 
    public Map<String, Object> getMembers(MemberSearchDto dto) {
        if (dto.getPage() <= 0) dto.setPage(1);

        int totalCount = memberMapper.countMembers(dto);
        dto.setTotalRows(totalCount);
        dto.calculatePagination();

        List<MemberListDto> list = memberMapper.getPagedMembers(dto);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("pagination", dto);
        return result;
    }

    // 부서정보 조회
    public List<DeptDto> getDeptList() {
        return memberMapper.getDeptList();
    }

    // 직급 정보 조회
    public List<RankDto> getRankList() {
        return memberMapper.getRankList();
    }

    // 사원등록
    public boolean insertMember(MemberFormDto dto, MultipartFile file) {
        // 입사년도
        String year = String.valueOf(dto.getMemHiredate().getYear());
        // 4자리숫자 조회 + 1 
        String seq = memberMapper.nextMemId(year);
        // 아이디 생성
        String memId = "LDB" + year + seq;
        // 이메일 : 사원아이디 + 이메일
        String memEmail = memId + "@ldb.com";
        // 비밀번호 암호화 처리 (1234 자동 발급)
        String memPass = BCrypt.hashpw("1234", BCrypt.gensalt());
        // 주민번호 뒷자리 암호화
        String juminBack = cipherUtil.encrypt(dto.getJuminBack(), memId);

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
            attachmentService.saveAttachments(memId, "P", List.of(file));
        }
        return true;
    }

    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(UpdateMemberDto dto) {
        int updated = memberMapper.updateMemberByMng(dto);
        if (updated <= 0) {
            return ApiResponseDto.fail("사원 정보 수정 실패");
        }
        return ApiResponseDto.ok(dto, "사원 정보 수정 완료");
    }

    //
    public boolean updateInfo(MemberUpdateDto dto) {
        if (dto.getDeletePhoto() != null && !dto.getDeletePhoto().isEmpty()) {
            attachmentService.deleteAttachment(List.of(dto.getDeletePhoto()));
        }

        if (dto.getPhoto() != null && !dto.getPhoto().isEmpty()) {
            attachmentService.saveAttachments(dto.getMemId(), "P", List.of(dto.getPhoto()));
        }
        memberMapper.updateInfo(dto);
        return true;
    }

    // 새로입력한 비밀번호 암호화
    public boolean checkPw(String memId, String rawPassword) {
        String pass = memberMapper.checkPw(memId);
        if (pass == null) {
            return false;
        }
        return BCrypt.checkpw(rawPassword, pass);
    }

    // 비밀번호 변경
    public boolean changePw(String memId, String newPassword) {
        String hashPw = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        memberMapper.changePw(memId, hashPw);
        return true;
    }

    // 개인정보 조회
    public MemberInfoDto getMemberInfo(String memId) {
        MemberInfoDto dto = memberMapper.selectMemberInfo(memId);
        if (dto == null) return null;

        if (dto.getJuminBack() != null && dto.getJuminBack().matches("^[0-9a-fA-F]+$")) {
            try {
                dto.setJuminBack(cipherUtil.decrypt(dto.getJuminBack(), memId));
            } catch (Exception e) {
                log.error("주민번호 복호화 실패: {}", memId, e);
            }
        } else {
            log.warn("복호화 생략 - 평문 형식으로 판단됨: {}", dto.getJuminBack());
        }

        List<MemberAnnualLeaveHistoryDto> history = memberMapper.selectAnnualLeaveHistory(memId);
        dto.setAnnualHistoryList(history);

        return dto;
    }

}
