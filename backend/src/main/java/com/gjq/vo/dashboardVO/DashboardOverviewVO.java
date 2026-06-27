package com.gjq.vo.dashboardVO;

import lombok.Data;

import java.util.List;

@Data
public class DashboardOverviewVO {
    private List<DashboardStatVO> stats;
    private List<DashboardRevenueVO> weeklyRevenue;
    private List<DashboardFleetStatusVO> fleetStatus;
    private Integer fleetTotal;
    private List<DashboardLeaseVO> activeLeases;
    private List<DashboardTodoVO> todos;
    private List<DashboardFinanceMonthVO> financeMonthly;
    private List<DashboardFinanceTypeVO> financeByType;

    @Data
    public static class DashboardStatVO {
        private String key;
        private String label;
        private String valueMain;
        private String valueLight;
        private String icon;
        private String tone;
        private String trend;
        private String trendTone;
    }

    @Data
    public static class DashboardRevenueVO {
        private String day;
        private Double value;
    }

    @Data
    public static class DashboardFleetStatusVO {
        private String name;
        private Integer value;
        private String color;
    }

    @Data
    public static class DashboardLeaseVO {
        private String plate;
        private String model;
        private String customer;
        private String start;
        private String end;
        private Integer progress;
    }

    @Data
    public static class DashboardTodoVO {
        private String title;
        private String desc;
        private String tag;
        private String tone;
    }

    @Data
    public static class DashboardFinanceMonthVO {
        private String month;
        private Integer revenue;
        private Integer cost;
        private Integer orders;
    }

    @Data
    public static class DashboardOrderNumVO {
        private Integer days;
        private Integer rentalNum;
    }

    @Data
    public static class DashboardFinanceTypeVO {
        private Integer value;
        private String name;
        private DashboardItemStyleVO itemStyle;
    }

    @Data
    public static class DashboardItemStyleVO {
        private String color;
    }
}
