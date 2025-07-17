package ldb.groupware.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@ToString
public class member {
   private String memId;
   private String deptId;
   private String rankId;
   private String memName;
   private String memGender;
   private String memEmail;
   private String memPass;
   private String memPhone;
   private String juminFront;
   private String juminBack;
   private String memAddress;
   private String memPicture;
   private String memStatus;
   private Date memHiredate;
   private Date resignDate;
   private String createdBy;
   private Date createdDate;
   private String updatedBy;
   private Date updatedDate;
}
