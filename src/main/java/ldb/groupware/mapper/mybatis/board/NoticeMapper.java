package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.AttachUpdateDto;
import ldb.groupware.dto.board.NoticeDetailDto;
import ldb.groupware.dto.board.NoticeFormDto;
import ldb.groupware.dto.board.NoticeListDto;
import ldb.groupware.dto.common.AttachmentDto;
import ldb.groupware.dto.common.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface NoticeMapper {
    int noticeCount();

    List<NoticeListDto> getNoticeList(PaginationDto pageDto);

    void insertNotice(NoticeFormDto dto);

    String getMember(String id);

    int getMaxNum(String memId);

    void insertAttach(AttachmentDto attach);

   NoticeDetailDto getNoticeById(String id);

   List<AttachmentDto> getAttachByNoticeId(String id);

    void deleteFile(AttachUpdateDto attach);
}
