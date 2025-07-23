package ldb.groupware.service.board;

import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.dto.board.QnaListDto;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import ldb.groupware.mapper.mybatis.board.QnaMapper;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class QnaService {
    private final QnaMapper mapper;
    private final FaqMapper faqMapper;

    public QnaService(QnaMapper mapper , FaqMapper faqMapper) {
        this.mapper = mapper;
        this.faqMapper = faqMapper;
    }//생성자주입으로 DI
    
    public Map<String, Object> getQnaList(PaginationDto paging) {
        HashMap<String, Object> map = new HashMap<>();
        int count = mapper.countQna();
        paging.setTotalRows(count);
        paging.calculatePagination();
        List<QnaListDto> list = mapper.getQnaList(paging);
        for(QnaListDto dto : list){
            dto.setDateFormat(); //LocalDateTime->String
        }
        List<FaqListDto> faq = faqMapper.findList(5); //상위5개의 자주묻는질문만가져와;
        map.put("pageDto", paging);
        map.put("qna", list);
        map.put("faq", faq);
        return map;
    }
}
