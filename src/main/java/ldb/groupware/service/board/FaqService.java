package ldb.groupware.service.board;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.FaqFormDto;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class FaqService {

    private  final FaqMapper mapper;


    public Map<String,Object> findFaqList(PaginationDto pageDto) {
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
        if(a>0) {
            return true;
        }
        else{
            return false;
        }
    }
}
