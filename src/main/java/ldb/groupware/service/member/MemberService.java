package ldb.groupware.service.member;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.member.*;
import ldb.groupware.mapper.mybatis.member.MemberMapper;
import ldb.groupware.service.attachment.AttachmentService;
import ldb.groupware.util.CipherUtil;
import ldb.groupware.util.MailUtil;
import lombok.extern.slf4j.Slf4j;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class MemberService {

    private final MemberMapper memberMapper;
    private final AttachmentService attachmentService;
    private final CipherUtil cipherUtil;
    private final MailUtil mailUtil;

    // 인증번호 저장을 위한 설정
    private final Map<String, String> authCode = new ConcurrentHashMap<>();


    public MemberService(MemberMapper memberMapper, AttachmentService attachmentService, CipherUtil cipherUtil, MailUtil mailUtil) {
        this.memberMapper = memberMapper;
        this.attachmentService = attachmentService;
        this.cipherUtil = cipherUtil;
        this.mailUtil = mailUtil;
    }

    // 연차사용 내역 조회
    public List<MemberAnnualLeaveHistoryDto> getAnnualLeaveHistory(String memId) {
        return memberMapper.selectAnnualLeaveHistory(memId);
    }

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
    public boolean insertMember(MemberFormDto dto, MultipartFile file, String loginId) {
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

        dto.setMemId(memId);
        dto.setMemPass(memPass);
        dto.setMemEmail(memEmail);
        dto.setJuminBack(juminBack);
        dto.setCreatedBy(loginId);

        memberMapper.insertMember(dto);


        if (file != null && !file.isEmpty()) {
            attachmentService.saveAttachments(memId, "P", List.of(file));
        }

        try {
            mailUtil.send(dto.getMemPrivateEmail(), "[LDBSOFT] 사원등록 안내", "아이디 : " + memId + "<br>비밀번호 : 1234");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    // 사원 설정(부서,직급)
    public ResponseEntity<ApiResponseDto<UpdateMemberDto>> updateMemberByMng(UpdateMemberDto dto, String loginId) {
        dto.setUpdatedBy(loginId);
        int updated = memberMapper.updateMemberByMng(dto);
        if (updated <= 0) {
            return ApiResponseDto.fail("사원 정보 수정 실패");
        }
        return ApiResponseDto.ok(dto, "사원 정보 수정 완료");
    }

    // 사원정보 수정
    public boolean updateInfo(MemberUpdateDto dto, String memId) {
        if (dto.getDeletePhoto() != null && !dto.getDeletePhoto().isEmpty()) {
            attachmentService.deleteAttachment(List.of(dto.getDeletePhoto()), "P");
        }

        if (dto.getPhoto() != null && !dto.getPhoto().isEmpty()) {
            attachmentService.saveAttachments(dto.getMemId(), "P", List.of(dto.getPhoto()));
        }
        dto.setUpdatedBy(memId);
        memberMapper.updateInfo(dto);
        return true;
    }

    // 새로입력한 비밀번호 암호화
    public boolean checkPw(String memId, String rawPassword) {
        String pass = memberMapper.checkPw(memId);
        if (pass == null || rawPassword == null) {
            return false;
        }
        return BCrypt.checkpw(rawPassword, pass);
    }

    // 비밀번호 변경
    public boolean changePw(String memId, String newPassword) {
        String hashPw = BCrypt.hashpw(newPassword, BCrypt.gensalt()); // 새로운 비밀번호 암호화
        return memberMapper.changePw(memId, hashPw) > 0;
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

    //id로 이름꺼내오기(동곤)
    public String findNameById(String id) {
        return memberMapper.findNameById(id);
    }

    // 인증번호 전송
    public ResponseEntity<ApiResponseDto<Void>> sendCode(PwCodeDto dto) {
        if (!memberMapper.isValidMember(dto)) {
            return ApiResponseDto.fail("사원정보를 확인해주세요.");
        }
        String code = String.valueOf((int) (Math.random() * 900000 + 100000));
        System.out.println("code::::::::::" + code);
        authCode.put(dto.getMemId(), code);

        try {
            mailUtil.send(dto.getMemPrivateEmail(), "[LDBSOFT] 인증번호 안내", "인증번호 : " + code);
        } catch (Exception e) {
            return ApiResponseDto.error("인증번호 전송이 실패 했습니다");
        }
        return ApiResponseDto.successMessage("인증번호 전송이 성공했습니다.");
    }

    // 인증번호 검사
    public ResponseEntity<ApiResponseDto<Void>> verifyCode(CodeDto dto) {
        String saved = authCode.get(dto.getMemId());
        if (saved == null || !saved.equals(dto.getInputCode())) {
            return ApiResponseDto.fail("인증번호가 일치하지 않습니다.");
        }
        return ApiResponseDto.successMessage("인증번호가 일치 합니다");
    }

    // 임시 이메일 전송
    public ResponseEntity<ApiResponseDto<Void>> sendTemp(String memId) {
        String tempPw = genTempPw(10);
        String ewc = BCrypt.hashpw(tempPw, BCrypt.gensalt());
        int reuslt = memberMapper.changePw(memId, ewc);
        if (reuslt <= 0) {
            return ApiResponseDto.fail("비밀번호 변경 실패했습니다");
        }
        String email = memberMapper.selectEmail(memId);

        try {
            mailUtil.send(email, "[LDBSOFT] 임시 비밀번호 안내", "임시 비밀번호 : " + tempPw);
        } catch (Exception e) {
            return ApiResponseDto.error("이메일 전송에 실패 했습니다");
        }
        return ApiResponseDto.successMessage("임시 비밀번호가 전송되었습니다.");

    }

    // 비밀번호 재설정
    public ResponseEntity<ApiResponseDto<Void>> resetPw(ResetPwDto dto) {
        if (!dto.getNewPw().equals(dto.getConfirmPw())) {
            return ApiResponseDto.fail("비밀번호가 일치 하지않습니다");
        }
        String hashPw = BCrypt.hashpw(dto.getNewPw(), BCrypt.gensalt());
        int updated = memberMapper.changePw(dto.getMemId(), hashPw);
        if (updated <= 0) {
            return ApiResponseDto.fail("비밀번호 변경 실패 했습니다");
        }
        return ApiResponseDto.successMessage("비밀번호 변경 성공했습니다");
    }

    // 임시비밀번호 랜덤하게
    private String genTempPw(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int idx = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(idx));
        }
        return sb.toString();
    }

    public List<MemberListDto> getMemberList() {
        return memberMapper.getMemberList();
    }

    public AuthDto selectAuth(String loginId) {
        return memberMapper.selectAuth(loginId);
    }
}
