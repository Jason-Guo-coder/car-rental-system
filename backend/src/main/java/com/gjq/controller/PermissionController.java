package com.gjq.controller;

import cn.hutool.core.util.StrUtil;
import com.gjq.entity.Permission;
import com.gjq.service.IPermissionService;
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
@RequestMapping("/rental/permission")
public class PermissionController {

    @Resource
    private IPermissionService permissionService;

    @GetMapping
    public Result list() {
        return Result.success(permissionService.selectList());
    }

    @GetMapping("/tree")
    public Result tree() {
        return Result.success(permissionService.selectTree());
    }

    @PostMapping
    public Result save(@RequestBody Permission permission){
        Integer permissionType = permission.getPermissionType();
        if (permissionType != null && permissionType != 2) {
            String routeUrl = permission.getRouteUrl();
            if (StrUtil.isNotEmpty(routeUrl) && routeUrl.contains("/")) {
                permission.setRouteName(routeUrl.substring(routeUrl.lastIndexOf("/") + 1));
                permission.setRoutePath(routeUrl.substring(routeUrl.lastIndexOf("/")));
            }
        }
        return permissionService.save(permission) ? Result.success() : Result.fail();
    }

    @PutMapping
    public Result update(@RequestBody Permission permission){
        Integer permissionType = permission.getPermissionType();
        if (permissionType != null && permissionType != 2) {
            String routeUrl = permission.getRouteUrl();
            if (StrUtil.isNotEmpty(routeUrl) && routeUrl.contains("/")) {
                permission.setRouteName(routeUrl.substring(routeUrl.lastIndexOf("/") + 1));
                permission.setRoutePath(routeUrl.substring(routeUrl.lastIndexOf("/")));
            }
        }
        return permissionService.updateById(permission) ? Result.success() : Result.fail();
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id){
        return permissionService.removeById(id) ? Result.success() : Result.fail();
    }

    @GetMapping("/hasChildren/{id}")
    public Result hasChildren(@PathVariable Integer id){
        return permissionService.hasChildren(id) ? Result.success().setMessage("有") : Result.success().setMessage("无");
    }
}
