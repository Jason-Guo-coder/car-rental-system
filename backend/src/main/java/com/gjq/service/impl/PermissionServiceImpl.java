package com.gjq.service.impl;

import com.gjq.entity.Permission;
import com.gjq.mapper.PermissionMapper;
import com.gjq.service.IPermissionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
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
}
