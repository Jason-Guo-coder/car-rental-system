package com.gjq.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Role;
import com.gjq.service.IPermissionService;
import com.gjq.service.IRoleService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
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
@RequestMapping("/rental/role")
public class RoleController {

    @Resource
    private IRoleService roleService;

    @Resource
    private IPermissionService permissionService;

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable Integer start, @PathVariable Integer size, @RequestBody Role role){

        Page<Role> page = new Page<>(start,size);
        return Result.success(roleService.selectList(page,role));
    }

    @PostMapping
    @PreAuthorize("hasAnyAuthority('sys:role:save')")
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

    //获取菜单的树结构   当前角色id，用户id
    @GetMapping("/permissionTrees")
    public Result selectPermissionTree(Integer userId,Integer roleId){
        return Result.success(permissionService.selectPermissionTree(userId, roleId));
    }

    //权限分配
    @GetMapping("/{roleId}/{permissionIds}")
    public Result assignPermission(@PathVariable int roleId, @PathVariable String permissionIds) {
        List<Integer> list = Arrays.stream(permissionIds.split(",")).map(Integer::parseInt).toList();
        return roleService.assignPermission(roleId, list) ? Result.success() : Result.fail();
    }

    //无分页的角色查询
    @GetMapping
    public Result list() {
        return Result.success(roleService.list());
    }


}
