package ldb.groupware.service.board;

import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.common.DeptDto;
import ldb.groupware.dto.common.PaginationDto;
import ldb.groupware.mapper.mapstruct.ConvertDtoMapper;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class FaqService {

    private final FaqMapper mapper;
    private final ConvertDtoMapper convertDtoMapper;

    public Map<String, Object> findFaqList(PaginationDto pageDto) {
        HashMap<String, Object> map = new HashMap<>();
        int count = mapper.faqCount();
        pageDto.setTotalRows(count);
        pageDto.calculatePagination(); //최대row를 이용해 최대페이지등을 정해줌
        List<FaqListDto> list = mapper.findFaqList(pageDto);

        map.put("list", list);
        map.put("pageDto", pageDto);
        return map;
    }

    public boolean insertFaq(FaqFormDto dto) {
        int a = mapper.insertFaq(dto);
        if (a > 0) {
            return true;
        } else {
            return false;
        }
    }

    public FaqFormDto findById(String faqId) {
        Integer i = Integer.valueOf(faqId);
        FaqFormDto faq = mapper.findById(i);

        return faq;
    }

    public List<DeptDto> deptAll() {
        List<DeptDto> dto = mapper.deptAll();

        return dto;
    }

    public boolean updateFaq(FaqFormDto dto) {
        int result = mapper.updateFaq(dto);
        return true;
    }

    public boolean deleteFaq(String faqId) {
        Integer i = Integer.valueOf(faqId);
        int result = mapper.deleteFaq(i);
        if (result > 0) {
            return true;
        }
        return false;
    }
}
