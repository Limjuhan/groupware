package ldb.groupware.service.board;

import ldb.groupware.dto.board.FaqListDto;
import ldb.groupware.mapper.mybatis.board.FaqMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FaqService {

    private  final FaqMapper mapper;


    public List<FaqListDto> findFaqList(){
        List<FaqListDto> list = mapper.findFaqList();
        System.out.println(list);
        return list;
    }

}
