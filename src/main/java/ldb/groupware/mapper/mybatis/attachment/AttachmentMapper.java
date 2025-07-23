package ldb.groupware.mapper.mybatis.attachment;

import ldb.groupware.domain.Attachment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AttachmentMapper {

    void insert(Attachment attach);

    void delete(String savedName);
}
