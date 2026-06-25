package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Order;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IOrderService extends IService<Order> {

    boolean insert(Order order);

    Page searchByPage(Page<Order> page, Order order);

    boolean returnAuto(Order order, Integer maintainMileage);

    Page search(Page<Order> page, Order order);

    long countViolation(Integer autoId);
}
