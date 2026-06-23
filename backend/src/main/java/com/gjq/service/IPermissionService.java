package com.gjq.service;

import com.gjq.entity.Permission;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IPermissionService extends IService<Permission> {
    List<Permission> selectPermissionListByUserId(Integer id);
}
