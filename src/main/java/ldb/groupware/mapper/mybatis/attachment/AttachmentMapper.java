package ldb.groupware.mapper.mybatis.attachment;

import ldb.groupware.domain.Attachment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AttachmentMapper {

    void insert(Attachment attach);

    void delete(String savedName);

    List<Attachment> getAttachments(@Param("businessId") String businessId,
                                @Param("attachType") String attachType);


}
