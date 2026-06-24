package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Role;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IRoleService extends IService<Role> {
    Page<Role> selectList(Page<Role> page , Role role);

    boolean hasUser(Integer id);

    boolean delete(String ids);
}
