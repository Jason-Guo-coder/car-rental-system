package com.gjq.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoInfo;
import com.gjq.entity.Order;
import com.gjq.mapper.AutoInfoMapper;
import com.gjq.mapper.OrderMapper;
import com.gjq.service.IOrderService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements IOrderService {

    @Resource
    private AutoInfoMapper autoInfoMapper;

    @Resource
    private OrderMapper orderMapper;

    @Override
    public boolean insert(Order order) {
        //将当前车辆的状态，由未租改成已租
        Integer autoId = order.getAutoId();
        AutoInfo autoInfo = autoInfoMapper.selectById(autoId);
        autoInfo.setStatus(1);
        autoInfoMapper.updateById(autoInfo);
        //生成订单编号
        String number = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS").format(LocalDateTime.now());
        order.setOrderNum(number);
        order.setRentalTime(LocalDateTime.now());
        return orderMapper.insert(order)>0;
    }

    @Override
    public Page searchByPage(Page<Order> page, Order order) {
        return orderMapper.searchUnfinished(page,order);
    }

    @Override
    public boolean returnAuto(Order order,Integer maintainMileage) {
        //修改车辆状态
        try {
            Integer autoId = order.getAutoId();
            AutoInfo autoInfo = autoInfoMapper.selectById(autoId);
            autoInfo.setStatus(0);
            //增加车辆行驶里程
            autoInfo.setMileage(order.getReturnMileage());
            //修改应保次数
            autoInfo.setExpectedNum(autoInfo.getMileage() / maintainMileage);
            autoInfoMapper.updateById(autoInfo);
            //update更新订单
            baseMapper.updateById(order);
            return true;
        }catch (Exception e){
            throw new RuntimeException("归还失败");
        }
    }

    @Override
    public Page search(Page<Order> page, Order order) {
        return orderMapper.search(page,order);
    }

    @Override
    public long countViolation(Integer autoId) {
        return orderMapper.countViolation(autoId);
    }
}
