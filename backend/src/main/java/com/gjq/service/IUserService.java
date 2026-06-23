package com.gjq.service;

import com.gjq.entity.User;
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
public interface IUserService extends IService<User> {

    User selectByUsername(String username);

    List<String> selectRoleName(int id);
}
