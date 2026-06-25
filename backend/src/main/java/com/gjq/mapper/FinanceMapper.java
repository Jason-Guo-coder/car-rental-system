package com.gjq.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gjq.vo.financeVO.FinanceCostVO;
import com.gjq.vo.financeVO.FinanceNumDayVO;
import com.gjq.vo.financeVO.FinanceNumMonthVO;
import org.apache.poi.ss.formula.functions.Finance;

import java.util.List;


public interface FinanceMapper extends BaseMapper<Finance> {

    List<FinanceNumDayVO> countDayRental();

    List<FinanceNumDayVO> countDayReturn();

    List<FinanceNumMonthVO> countMonthRental();

    List<FinanceNumMonthVO> countMonthReturn();

    FinanceCostVO sumRentPay();

    Integer sumDeposit();
    FinanceCostVO sumRentPayMonth();

    Integer sumDepositMonth();
}
