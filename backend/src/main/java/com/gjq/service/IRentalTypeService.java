package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.RentalType;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IRentalTypeService extends IService<RentalType> {

    Object searchByPage(Page<RentalType> page, RentalType rentalType);

    boolean delete(String ids);
}
