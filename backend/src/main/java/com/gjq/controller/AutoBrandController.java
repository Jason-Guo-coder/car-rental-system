package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoBrand;
import com.gjq.service.IAutoBrandService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@RestController
@RequestMapping("/rental/autoBrand")
public class AutoBrandController {

    @Resource
    private IAutoBrandService autoBrandService;

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size, @RequestBody AutoBrand autoBrand) {
        Page<AutoBrand> page = new Page<>(start, size);
        return Result.success().setData(autoBrandService.searchByPage(page, autoBrand));
    }

    @PostMapping
    public Result save(@RequestBody AutoBrand autoBrand) {
        return autoBrandService.save(autoBrand) ? Result.success() : Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody AutoBrand autoBrand) {
        return autoBrandService.updateById(autoBrand) ? Result.success() : Result.fail();
    }

    @DeleteMapping("/{ids}")
    public Result delete(@PathVariable String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        return autoBrandService.removeByIds(list) ? Result.success() : Result.fail();
    }
}
