package com.gjq.service.impl;

import com.gjq.mapper.DashboardMapper;
import com.gjq.service.IDashboardService;
import com.gjq.vo.dashboardVO.DashboardOverviewVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class DashboardServiceImpl implements IDashboardService {

    @Resource
    private DashboardMapper dashboardMapper;

    @Override
    public DashboardOverviewVO overview() {
        Integer fleetTotal = nvl(dashboardMapper.countFleetTotal());
        Integer idle = nvl(dashboardMapper.countFleetStatus(0));
        Integer renting = nvl(dashboardMapper.countFleetStatus(1));
        Integer maintain = nvl(dashboardMapper.countFleetStatus(2));
        Integer selfUse = nvl(dashboardMapper.countFleetStatus(3));
        Integer monthOrder = nvl(dashboardMapper.countMonthOrder());
        Integer pendingViolation = nvl(dashboardMapper.countPendingViolation());
        Integer monthRentActual = nvl(dashboardMapper.sumMonthRentActual());
        Integer monthRentPayable = nvl(dashboardMapper.sumMonthRentPayable());
        Integer monthDeposit = nvl(dashboardMapper.sumMonthDeposit());

        DashboardOverviewVO vo = new DashboardOverviewVO();
        vo.setStats(buildStats(fleetTotal, renting, monthOrder, pendingViolation, monthRentActual));
        vo.setWeeklyRevenue(dashboardMapper.selectWeeklyRevenue());
        vo.setFleetStatus(buildFleetStatus(idle, renting, maintain, selfUse));
        vo.setFleetTotal(fleetTotal);
        vo.setActiveLeases(dashboardMapper.selectActiveLease());
        vo.setTodos(dashboardMapper.selectTodo());
        vo.setFinanceMonthly(buildFinanceMonthly(monthRentActual));
        vo.setFinanceByType(buildFinanceByType(monthRentPayable, monthRentActual, monthDeposit));
        return vo;
    }

    private List<DashboardOverviewVO.DashboardStatVO> buildStats(Integer fleetTotal, Integer renting,
                                                                 Integer monthOrder, Integer pendingViolation,
                                                                 Integer monthRentActual) {
        List<DashboardOverviewVO.DashboardStatVO> list = new ArrayList<>();
        list.add(stat("revenue", "本月营收", "¥" + String.format("%.1f", monthRentActual / 1000.0), "k",
                "Money", "blue", "实时", "flat"));
        list.add(stat("renting", "在租车辆", String.valueOf(renting), "/" + fleetTotal + " 辆",
                "Van", "green", fleetTotal == 0 ? "利用率 0%" : "利用率 " + Math.round(renting * 100.0 / fleetTotal) + "%", "flat"));
        list.add(stat("orders", "本月订单", String.valueOf(monthOrder), " 单",
                "Tickets", "orange", "实时", "flat"));
        list.add(stat("violation", "待处理违章", String.valueOf(pendingViolation), " 起",
                "Warning", "red", "需关注", "warn"));
        return list;
    }

    private DashboardOverviewVO.DashboardStatVO stat(String key, String label, String valueMain, String valueLight,
                                                     String icon, String tone, String trend, String trendTone) {
        DashboardOverviewVO.DashboardStatVO vo = new DashboardOverviewVO.DashboardStatVO();
        vo.setKey(key);
        vo.setLabel(label);
        vo.setValueMain(valueMain);
        vo.setValueLight(valueLight);
        vo.setIcon(icon);
        vo.setTone(tone);
        vo.setTrend(trend);
        vo.setTrendTone(trendTone);
        return vo;
    }

    private List<DashboardOverviewVO.DashboardFleetStatusVO> buildFleetStatus(Integer idle, Integer renting,
                                                                              Integer maintain, Integer selfUse) {
        List<DashboardOverviewVO.DashboardFleetStatusVO> list = new ArrayList<>();
        list.add(fleetStatus("未租", idle, "#3B83F5"));
        list.add(fleetStatus("已租", renting, "#22b07d"));
        list.add(fleetStatus("维保", maintain, "#f5a623"));
        list.add(fleetStatus("自用", selfUse, "#9b5de5"));
        return list;
    }

    private DashboardOverviewVO.DashboardFleetStatusVO fleetStatus(String name, Integer value, String color) {
        DashboardOverviewVO.DashboardFleetStatusVO vo = new DashboardOverviewVO.DashboardFleetStatusVO();
        vo.setName(name);
        vo.setValue(value);
        vo.setColor(color);
        return vo;
    }

    private List<DashboardOverviewVO.DashboardFinanceMonthVO> buildFinanceMonthly(Integer monthRentActual) {
        List<DashboardOverviewVO.DashboardOrderNumVO> orderNums = dashboardMapper.selectMonthOrderNum();
        List<DashboardOverviewVO.DashboardFinanceMonthVO> list = new ArrayList<>();
        Integer avgRevenue = orderNums.isEmpty() ? 0 : monthRentActual / orderNums.size();
        orderNums.forEach(item -> {
            DashboardOverviewVO.DashboardFinanceMonthVO vo = new DashboardOverviewVO.DashboardFinanceMonthVO();
            vo.setMonth(item.getDays() + "日");
            vo.setRevenue(avgRevenue);
            vo.setCost(0);
            vo.setOrders(item.getRentalNum());
            list.add(vo);
        });
        return list;
    }

    private List<DashboardOverviewVO.DashboardFinanceTypeVO> buildFinanceByType(Integer monthRentPayable,
                                                                                Integer monthRentActual,
                                                                                Integer monthDeposit) {
        List<DashboardOverviewVO.DashboardFinanceTypeVO> list = new ArrayList<>();
        list.add(financeType(monthRentPayable, "应收租金", "#5b8def"));
        list.add(financeType(monthRentActual, "实收租金", "#22b07d"));
        list.add(financeType(monthDeposit, "押金", "#f5a623"));
        return list;
    }

    private DashboardOverviewVO.DashboardFinanceTypeVO financeType(Integer value, String name, String color) {
        DashboardOverviewVO.DashboardFinanceTypeVO vo = new DashboardOverviewVO.DashboardFinanceTypeVO();
        DashboardOverviewVO.DashboardItemStyleVO itemStyle = new DashboardOverviewVO.DashboardItemStyleVO();
        itemStyle.setColor(color);
        vo.setValue(value);
        vo.setName(name);
        vo.setItemStyle(itemStyle);
        return vo;
    }

    private Integer nvl(Integer value) {
        return value == null ? 0 : value;
    }
}
