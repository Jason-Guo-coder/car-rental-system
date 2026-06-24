package com.gjq.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.gjq.entity.Permission;
import com.gjq.mapper.PermissionMapper;
import com.gjq.service.IPermissionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gjq.utils.RouteTreeUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

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
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, Permission> implements IPermissionService {

    @Resource
    private PermissionMapper permissionMapper;

    @Override
    public List<Permission> selectPermissionListByUserId(Integer userId) {
        return permissionMapper.selectPermissionListByUserId(userId);
    }

    @Override
    public List<Permission> selectList() {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("order_num");
        List<Permission> permissionList = baseMapper.selectList(queryWrapper);
        return RouteTreeUtils.buildMenuTree(permissionList,0);
    }

    @Override
    public List<Permission> selectTree() {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.ne("permission_type",2);
        queryWrapper.orderByAsc("order_num");
        List<Permission> permissions= baseMapper.selectList(queryWrapper);
        Permission permission=new Permission();
        permission.setId(0).setPid(-1).setPermissionLable("根目录");
        permissions.add(permission);
        return RouteTreeUtils.buildMenuTree(permissions, -1);
    }

    @Override
    public boolean hasChildren(Integer id) {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("pid", id);
        return baseMapper.selectCount(queryWrapper) > 0;
    }
}
