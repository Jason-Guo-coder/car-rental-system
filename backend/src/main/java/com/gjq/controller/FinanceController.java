package com.gjq.controller;

import com.gjq.service.IFinanceService;
import com.gjq.utils.Result;
import com.gjq.vo.financeVO.FinanceCostVO;
import com.gjq.vo.financeVO.FinanceNumDayVO;
import com.gjq.vo.financeVO.FinanceNumMonthVO;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/rental/finance")
public class FinanceController {

    @Resource
    private IFinanceService financeService;

    @RequestMapping("countDayRental")
    public Result countDayRental(){
        //统计日租
        List<FinanceNumDayVO> rentalList = financeService.countDayRental();
        List<List<Object>> list=new ArrayList<>();
        List<Object> hoursList=new ArrayList<>();
        List<Object> rentalNumList=new ArrayList<>();
        rentalList.forEach(item->{
            hoursList.add(item.getHours());
            rentalNumList.add(item.getRentalNum());
        });
        list.add(hoursList);
        list.add(rentalNumList);
        return Result.success(list);
    }

    @RequestMapping("countDayReturn")
    public Result countDayReturn(){
        //统计日租
        List<FinanceNumDayVO> returnList = financeService.countDayReturn();
        List<List<Object>> list=new ArrayList<>();
        List<Object> hoursList=new ArrayList<>();
        List<Object> returnNumList=new ArrayList<>();
        returnList.forEach(item->{
            hoursList.add(item.getHours());
            returnNumList.add(item.getReturnNum());
        });
        list.add(hoursList);
        list.add(returnNumList);
        return Result.success(list);
    }

    @GetMapping("countDayCost")
    public Result countDayCost(){
        FinanceCostVO vo=financeService.sumRentPay();
        Integer deposit=financeService.sumDeposit();
        vo.setCountDeposit(deposit);
        return Result.success(vo);
    }

    @RequestMapping("countMonthRental")
    public Result countMonthRental(){
        //统计日租
        List<FinanceNumMonthVO> rentalList = financeService.countMonthRental();
        List<List<Object>> list=new ArrayList<>();
        List<Object> daysList=new ArrayList<>();
        List<Object> rentalNumList=new ArrayList<>();
        rentalList.forEach(item->{
            daysList.add(item.getDays());
            rentalNumList.add(item.getRentalNum());
        });
        list.add(daysList);
        list.add(rentalNumList);
        return Result.success(list);
    }

    @RequestMapping("countMonthReturn")
    public Result countMonthReturn(){
        //统计日租
        List<FinanceNumMonthVO> returnList = financeService.countMonthReturn();
        List<List<Object>> list=new ArrayList<>();
        List<Object> daysList=new ArrayList<>();
        List<Object> returnNumList=new ArrayList<>();
        returnList.forEach(item->{
            daysList.add(item.getDays());
            returnNumList.add(item.getReturnNum());
        });
        list.add(daysList);
        list.add(returnNumList);
        return Result.success(list);
    }

    @GetMapping("countMonthCost")
    public Result countMonthCost(){
        FinanceCostVO vo=financeService.sumRentPayMonth();
        Integer deposit=financeService.sumDepositMonth();
        vo.setCountDeposit(deposit);
        return Result.success(vo);
    }
}
