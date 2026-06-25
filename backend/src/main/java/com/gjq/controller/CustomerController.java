package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Customer;
import com.gjq.service.ICustomerService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@RestController
@RequestMapping("/rental/customer")
public class CustomerController {

    @Resource
    private ICustomerService customerService;

    @PostMapping
    public Result save(@RequestBody Customer customer) {
        // 保存成功后回填主键，返回新客户id（出租流程需用作 customerId）
        return customerService.save(customer) ? Result.success(customer.getId()) : Result.fail();
    }
    @PutMapping
    public Result update(@RequestBody Customer customer) {
        return customerService.updateById(customer) ? Result.success() : Result.fail();
    }
    @DeleteMapping("/{ids}")
    public Result delete(@PathVariable String ids) {
        return customerService.delete(ids) ? Result.success() : Result.fail();
    }

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size, @RequestBody Customer customer){
        Page<Customer> page = new Page<>(start, size);
        return Result.success(customerService.searchByPage(page, customer));
    }

    // 按联系电话查询客户（出租时回填老客户）
    @PostMapping("/tel")
    public Result selectCustomerByTel(@RequestBody Customer customer){
        return Result.success(customerService.selectCustomerByTel(customer.getTel()));
    }
}
