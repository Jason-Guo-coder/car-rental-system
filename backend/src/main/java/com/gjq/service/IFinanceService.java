package com.gjq.service;

import com.gjq.vo.financeVO.FinanceCostVO;
import com.gjq.vo.financeVO.FinanceNumDayVO;
import com.gjq.vo.financeVO.FinanceNumMonthVO;

import java.util.List;

public interface IFinanceService {

    List<FinanceNumDayVO> countDayRental();
    List<FinanceNumDayVO> countDayReturn();
    List<FinanceNumMonthVO> countMonthRental();
    List<FinanceNumMonthVO> countMonthReturn();

    FinanceCostVO sumRentPay();

    Integer sumDeposit();
    FinanceCostVO sumRentPayMonth();

    Integer sumDepositMonth();
}
