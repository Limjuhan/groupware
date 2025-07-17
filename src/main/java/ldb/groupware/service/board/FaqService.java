package ldb.groupware.service.board;

import jakarta.servlet.http.HttpServletRequest;
import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FaqService {

    private  final FaqMapper mapper;


    public List<FaqListDto> findFaqList(HttpServletRequest request) {
        int pageNum = 0;
        if(request.getParameter("page")!=null){
            pageNum = Integer.parseInt(request.getParameter("page"));
        }
        else{
            pageNum = 1;
        }
        int count = mapper.faqCount();
        System.out.println("count: " + count);
        List<FaqListDto> list = mapper.findFaqList();
        int limit = 5;
        return list;
    }

}
