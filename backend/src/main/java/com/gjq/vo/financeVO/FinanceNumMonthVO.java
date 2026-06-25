package com.gjq.vo.financeVO;

import lombok.Data;

@Data
public class FinanceNumMonthVO {
    //按月的天数
    private Integer days;
    //出租的数量
    private Integer rentalNum;
    //归还的数量
    private Integer returnNum;
}
