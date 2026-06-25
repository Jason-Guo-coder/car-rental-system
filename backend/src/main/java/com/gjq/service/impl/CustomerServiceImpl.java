package com.gjq.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Customer;
import com.gjq.mapper.CustomerMapper;
import com.gjq.service.ICustomerService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@Service
public class CustomerServiceImpl extends ServiceImpl<CustomerMapper, Customer> implements ICustomerService {

    @Resource
    private CustomerMapper customerMapper;

    @Override
    public Page searchByPage(Page<Customer> page, Customer customer) {
        QueryWrapper<Customer> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(ObjectUtil.isNotEmpty(customer.getName()), "name", customer.getName());
        queryWrapper.like(ObjectUtil.isNotEmpty(customer.getTel()), "tel", customer.getTel());
        queryWrapper.like(ObjectUtil.isNotEmpty(customer.getIdNum()), "id_num", customer.getIdNum());
        queryWrapper.le(ObjectUtil.isNotEmpty(customer.getHighAge()), "age", customer.getHighAge());
        queryWrapper.ge(ObjectUtil.isNotEmpty(customer.getLowAge()), "age", customer.getLowAge());
        queryWrapper.eq(ObjectUtil.isNotEmpty(customer.getGender()), "gender", customer.getGender());
        return customerMapper.selectPage(page, queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()){
            return customerMapper.deleteBatchIds(list) > 0;
        }
        return false;
    }

    @Override
    public Customer selectCustomerByTel(String tel) {
        QueryWrapper<Customer> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("tel", tel);
        return customerMapper.selectOne(queryWrapper);
    }
}
