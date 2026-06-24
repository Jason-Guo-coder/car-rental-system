package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Role;
import com.gjq.service.IRoleService;
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
@RequestMapping("/rental/role")
public class RoleController {

    @Resource
    private IRoleService roleService;

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable Integer start, @PathVariable Integer size, @RequestBody Role role){

        Page<Role> page = new Page<>(start,size);
        return Result.success(roleService.selectList(page,role));
    }

    @PostMapping
    public Result save(@RequestBody Role role){
        return roleService.save(role)?Result.success():Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody Role role){
        return roleService.updateById(role)?Result.success():Result.fail();
    }

    @GetMapping("/hasUser/{id}")
    public Result hasUser(@PathVariable Integer id){
        return roleService.hasUser(id) ? Result.success().setMessage("有") : Result.success().setMessage("无");
    }

    @DeleteMapping("/{ids}")
    public Result delete(@PathVariable String ids){
        return roleService.delete(ids)?Result.success():Result.fail();
    }
}
