package ldb.groupware.domain;

import lombok.Data;

@Data
public class LeaveType {

    private String leaveCode; //ANNUAL, HALF, EVENT
    private String leaveName;// 연차,반차, '경조사
    private Double leaveAmount; //1 , 0.5 , 0
}

