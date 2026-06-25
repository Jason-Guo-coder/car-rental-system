package com.gjq.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Order;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface OrderMapper extends BaseMapper<Order> {

    Page<Order> searchUnfinished(@Param("page") Page<Order> page , @Param("order") Order order);

    Page<Order> search(@Param("page") Page<Order> page , @Param("order") Order order);

    long countViolation(Integer autoId);
}
