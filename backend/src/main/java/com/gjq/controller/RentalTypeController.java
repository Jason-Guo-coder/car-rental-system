package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.RentalType;
import com.gjq.service.IRentalTypeService;
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
@RequestMapping("/rental/rentalType")
public class RentalTypeController {

    @Resource
    private IRentalTypeService rentalTypeService;

    @PostMapping("{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size,
                         @RequestBody RentalType rentalType){
        Page<RentalType> page=new Page<>(start,size);
        return Result.success(rentalTypeService.searchByPage(page,rentalType));
    }
    @PostMapping
    public Result save(@RequestBody RentalType rentalType){
        return rentalTypeService.save(rentalType)?Result.success():Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody RentalType rentalType){
        return rentalTypeService.updateById(rentalType)?Result.success():Result.fail();
    }
    @DeleteMapping("/{ids}")
    public Result delete(@PathVariable String ids){
        return rentalTypeService.delete(ids)?Result.success():Result.fail();
    }

}
