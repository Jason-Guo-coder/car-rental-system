package com.gjq.mapper;

import com.gjq.vo.financeVO.FinanceCostVO;
import com.gjq.vo.financeVO.FinanceNumDayVO;
import com.gjq.vo.financeVO.FinanceNumMonthVO;

import java.util.List;


public interface FinanceMapper {

    List<FinanceNumDayVO> countDayRental();

    List<FinanceNumDayVO> countDayReturn();

    List<FinanceNumMonthVO> countMonthRental();

    List<FinanceNumMonthVO> countMonthReturn();

    FinanceCostVO sumRentPay();

    Integer sumDeposit();
    FinanceCostVO sumRentPayMonth();

    Integer sumDepositMonth();
}
