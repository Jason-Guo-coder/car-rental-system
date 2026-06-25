package com.gjq.mapper;

import com.gjq.entity.Role;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface RoleMapper extends BaseMapper<Role> {

    List<Integer> selectRoleIdByUserId(Integer userid);
}
