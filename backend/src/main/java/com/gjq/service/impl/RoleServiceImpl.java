package com.gjq.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Role;
import com.gjq.entity.RolePermission;
import com.gjq.entity.User;
import com.gjq.entity.UserRole;
import com.gjq.mapper.RoleMapper;
import com.gjq.mapper.RolePermissionMapper;
import com.gjq.mapper.UserMapper;
import com.gjq.mapper.UserRoleMapper;
import com.gjq.service.IRoleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Arrays;
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
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private UserRoleMapper userRoleMapper;

    @Resource
    private RolePermissionMapper rolePermissionMapper;

    @Override
    public Page<Role> selectList(Page<Role> page, Role role) {

        QueryWrapper<Role> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(StrUtil.isNotEmpty(role.getRoleName()),"role_name",role.getRoleName());
        queryWrapper.orderByAsc("create_time");


        Integer userId = role.getCreaterId();

        User user = userMapper.selectById(userId);

        if (user != null && user.getIsAdmin() != 1) { //1是管理员
            queryWrapper.eq("creater_id", userId);
        }

        return baseMapper.selectPage(page, queryWrapper);
    }

    @Override
    public boolean hasUser(Integer id) {
        QueryWrapper<UserRole> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id",id);
        return userRoleMapper.selectCount(queryWrapper) > 0;
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()) {
            for (Integer id : list) {
                if (!hasUser(id)) {
                    rolePermissionMapper.delete(new QueryWrapper<RolePermission>().eq("role_id", id));
                    baseMapper.deleteById(id);
                }
            }
        }
        return true;
    }
}
