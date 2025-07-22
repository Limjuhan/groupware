package ldb.groupware.service.member;

import ldb.groupware.dto.apiresponse.ApiResponseDto;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.member.DeptDto;
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
    public MemberInfoDto getInfo(String memId) {
        return memberMapper.selectInfo(memId);
    }

    // 개인정보 수정 처리
    public boolean updateInfo(String memId, MemberUpdateDto dto) {
        MemberInfoDto existing = memberMapper.selectInfo(memId);

        String phone = isBlank(dto.getPhone()) ? existing.getMemPhone() : dto.getPhone();
        String privateEmail = isBlank(dto.getPrivateEmail()) ? existing.getMemPrivateEmail() : dto.getPrivateEmail();
        String address = isBlank(dto.getAddress()) ? existing.getMemAddress() : dto.getAddress();

        boolean result = memberMapper.updateInfo(memId, phone, privateEmail, address) > 0;

//        if (photo != null && !photo.isEmpty()) {
//            result = result && updatePhoto(memId, photo);
//        }

        return result;
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

    public boolean insertMember(MemberFormDto dto ,List<MultipartFile> files) {

        AttachmentDto attach = new AttachmentDto();
        // 1. 입사년도 추출
        String year = String.valueOf(dto.getMemHiredate().getYear()); // 예: "2025"

        // 2. 해당 입사년도 기준 다음 일련번호 조회 (4자리)
        String seq = memberMapper.nextMemId(year); // 예: "0001"

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
        for (MultipartFile file : files) {
            if(file!=null && !file.isEmpty()) {
                //String path = request.getServletContext().getRealPath("/")+"board/file/";
                String uploadDir = System.getProperty("user.dir") + "/upload/notice/";
                String savedName = this.uploadFileCreate(file, uploadDir);
                attach.setAttachType("P");
                String originalFilename = file.getOriginalFilename();
                attach.setSavedName(savedName); // saveName
                attach.setFilePath("/P/"); // 경로 + saveName
                attach.setOriginalName(originalFilename); //원본이름
                attach.setBusinessId(memId);
                memberMapper.insertAttach(attach);
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

    private String uploadFileCreate(MultipartFile file, String path) {
        String name = file.getOriginalFilename();
        String extension = name.substring(name.lastIndexOf("."));
        String orgFile = UUID.randomUUID().toString()+extension;
        File f = new File(path);
        if(!f.exists()) {
            f.mkdirs();
        }
        try {
            file.transferTo(new File(path+orgFile));
            return orgFile;
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
