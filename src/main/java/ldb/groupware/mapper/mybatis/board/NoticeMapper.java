package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.dto.board.*;
import ldb.groupware.dto.attach.AttachmentDto;
import ldb.groupware.dto.page.PaginationDto;
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

    void deleteFile(String file);

    int updateNotice(NoticeUpdateDto dto);

    void plusCnt(String id);

    int deleteNotice(int id);

    List<NoticeListDto> getPinnedList(PaginationDto pageDto);

    int pinnedCount();
}
