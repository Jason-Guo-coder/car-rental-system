package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoInfo;
import com.gjq.entity.Customer;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface ICustomerService extends IService<Customer> {

    Page searchByPage(Page<Customer> page , Customer customer);

    boolean delete(String ids);
}
