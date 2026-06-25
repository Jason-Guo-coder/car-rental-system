package com.gjq.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.gjq.entity.Permission;
import com.gjq.entity.User;
import com.gjq.mapper.PermissionMapper;
import com.gjq.mapper.UserMapper;
import com.gjq.service.IPermissionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gjq.utils.RouteTreeUtils;
import com.gjq.vo.RolePermissionVO;
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

    @Resource
    private UserMapper userMapper;

    @Override
    public List<Permission> selectPermissionListByUserId(Integer userId) {
        return permissionMapper.selectPermissionListByUserId(userId);
    }

    @Override
    public List<Permission> selectList() {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("order_num");
        List<Permission> permissionList = permissionMapper.selectList(queryWrapper);
        return RouteTreeUtils.buildMenuTree(permissionList,0);
    }

    @Override
    public List<Permission> selectTree() {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.ne("permission_type",2);
        queryWrapper.orderByAsc("order_num");
        List<Permission> permissions= permissionMapper.selectList(queryWrapper);
        Permission permission=new Permission();
        permission.setId(0).setPid(-1).setPermissionLable("根目录");
        permissions.add(permission);
        return RouteTreeUtils.buildMenuTree(permissions, -1);
    }

    @Override
    public boolean hasChildren(Integer id) {
        QueryWrapper<Permission> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("pid", id);
        return permissionMapper.selectCount(queryWrapper) > 0;
    }

    @Override
    public RolePermissionVO selectPermissionTree(Integer userId, Integer roleId) {
        // 先查当前登录用户
        User user = userMapper.selectById(userId);
        // 管理员看全部权限，普通用户看自己拥有的权限
        List<Permission> visiblePermissions = (user != null && user.getIsAdmin() == 1)
                ? permissionMapper.selectList(null)
                : permissionMapper.selectPermissionListByUserId(userId);

        // 把可见权限组装成树形结构
        List<Permission> permissionList = RouteTreeUtils.buildMenuTree(visiblePermissions, 0);

        // 查询这个角色已经拥有的权限
        List<Permission> rolePermissionList = permissionMapper.selectPermissionListByRoleId(roleId);

        // 提取角色已有权限的 id
        List<Integer> rolePermissionIds = rolePermissionList.stream().map(Permission::getId).toList();

        // 只保留“当前用户可见且角色已拥有”的权限 id
        Object[] array = visiblePermissions.stream()
                .map(Permission::getId)
                .filter(rolePermissionIds::contains)
                .toArray();

        // 组装返回结果
        return new RolePermissionVO().setCheckedList(array).setPermissionList(permissionList);
    }
}
