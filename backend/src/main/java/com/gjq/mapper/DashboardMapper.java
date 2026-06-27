package com.gjq.mapper;

import com.gjq.vo.dashboardVO.DashboardOverviewVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DashboardMapper {

    Integer countFleetTotal();

    Integer countFleetStatus(@Param("status") Integer status);

    Integer countMonthOrder();

    Integer countPendingViolation();

    Integer sumMonthRentActual();

    Integer sumMonthRentPayable();

    Integer sumMonthDeposit();

    List<DashboardOverviewVO.DashboardRevenueVO> selectWeeklyRevenue();

    List<DashboardOverviewVO.DashboardLeaseVO> selectActiveLease();

    List<DashboardOverviewVO.DashboardTodoVO> selectTodo();

    List<DashboardOverviewVO.DashboardOrderNumVO> selectMonthOrderNum();
}
