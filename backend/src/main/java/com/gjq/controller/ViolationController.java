package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Customer;
import com.gjq.entity.Violation;
import com.gjq.service.IViolationService;
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
@RequestMapping("/rental/violation")
public class ViolationController {

    @Resource
    private IViolationService violationService;

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size, @RequestBody Violation violation) {
        Page<Violation> page = new Page<>(start, size);
        return Result.success(violationService.searchByPage(page, violation));
    }

    @PostMapping
    public Result save(@RequestBody Violation violation) {
        return violationService.save(violation) ? Result.success() : Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody Violation violation) {
        return violationService.updateById(violation) ? Result.success() : Result.fail();
    }

    @DeleteMapping("/{ids}")
    public Result delete(@PathVariable String ids) {
        return violationService.delete(ids) ? Result.success() : Result.fail();
    }

}
