package com.gjq.service.impl;

import com.gjq.mapper.FinanceMapper;
import com.gjq.service.IFinanceService;
import com.gjq.vo.financeVO.FinanceCostVO;
import com.gjq.vo.financeVO.FinanceNumDayVO;
import com.gjq.vo.financeVO.FinanceNumMonthVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FinanceServiceImpl implements IFinanceService {
    @Resource
    private FinanceMapper financeMapper;

    @Override
    public List<FinanceNumDayVO> countDayRental() {
        return financeMapper.countDayRental();
    }

    @Override
    public List<FinanceNumDayVO> countDayReturn() {
        return financeMapper.countDayReturn();
    }

    @Override
    public List<FinanceNumMonthVO> countMonthRental() {
        return financeMapper.countMonthRental();
    }

    @Override
    public List<FinanceNumMonthVO> countMonthReturn() {
        return financeMapper.countMonthReturn();
    }

    @Override
    public FinanceCostVO sumRentPay() {
        return financeMapper.sumRentPay();
    }

    @Override
    public Integer sumDeposit() {
        return financeMapper.sumDeposit();
    }

    @Override
    public FinanceCostVO sumRentPayMonth() {
        return financeMapper.sumRentPayMonth();
    }

    @Override
    public Integer sumDepositMonth() {
        return financeMapper.sumDepositMonth();
    }
}
