package ldb.groupware.service.board;

import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.board.PaginationDto;
import ldb.groupware.mapper.mapstruct.ConvertDtoMapper;
import ldb.groupware.mapper.mybatis.board.NoticeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NoticeService {

    @Autowired
    private  NoticeMapper mapper;

    public Map<String, Object> getNoticeList(PaginationDto pageDto) {
        HashMap<String, Object> map = new HashMap<>();
        int count = mapper.noticeCount(); //공지사항의 전체 row 갯수
      pageDto.setTotalRows(count);
      pageDto.calculatePagination(); //보여줄 페이지의갯수 , 페이지당 제한갯수 등 설정
        System.out.println("pageDto : "+pageDto);
        List<NoticeListDto> dto = mapper.getNoticeList(pageDto);
        System.out.println("dto :: "+dto);
        map.put("notice", dto);
        map.put("pageDto", pageDto);
        return map;
    }
}
