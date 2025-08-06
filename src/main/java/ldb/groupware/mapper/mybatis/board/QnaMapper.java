package ldb.groupware.mapper.mybatis.board;

import ldb.groupware.domain.QnaComment;
import ldb.groupware.dto.board.*;
import ldb.groupware.dto.page.PaginationDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface QnaMapper {
    int countQna(PaginationDto paging);

    List<QnaListDto> getQnaList(PaginationDto paging);

    int insertQna(QnaFormDto dto);

    int maxQnaId(String memId);

    QnaDetailDto findQnaById(int id);

    void addViewCount(int id);

    List<QnaComment> findCommById(int id);

    int insertComment(CommentFormDto dto);

    int updateQna(QnaUpdateDto dto);

    int deleteById(int id);

    int deleteCommentById(int id);

    String getCommentWriter(int commentId);
}
