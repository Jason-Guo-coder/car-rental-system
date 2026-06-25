package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoInfo;
import com.gjq.entity.Maintain;
import com.gjq.service.IAutoInfoService;
import com.gjq.service.IMaintainService;
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
@RequestMapping("/rental/maintain")
public class MaintainController {

    @Resource
    private IMaintainService maintainService;

    @Resource
    private IAutoInfoService autoInfoService;

    @PostMapping("{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size, @RequestBody Maintain maintain){
        Page<Maintain> page = new Page<>(start, size);
        return Result.success(maintainService.searchByPage(page, maintain));
    }


    @PostMapping
    public Result save(@RequestBody Maintain maintain) {
        //设置保养关联的车辆信息
        AutoInfo autoInfo = autoInfoService.selectByAutoNum(maintain.getAutoNum());
        maintain.setAutoId(autoInfo.getId());
        //将车辆实保次数+1
        autoInfo.setActualNum(autoInfo.getActualNum() + 1);
        autoInfoService.updateById(autoInfo);
        return maintainService.save(maintain)?Result.success():Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody Maintain maintain) {
        return maintainService.updateById(maintain)?Result.success():Result.fail();
    }

    @DeleteMapping("{ids}")
    public Result delete(@PathVariable String ids) {
        return maintainService.delete(ids)?Result.success():Result.fail();
    }

}
