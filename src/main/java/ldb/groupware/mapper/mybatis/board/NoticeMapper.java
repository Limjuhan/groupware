package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.board.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface NoticeMapper {
    int noticeCount();

    List<NoticeListDto> getNoticeList(PaginationDto pageDto);
}
