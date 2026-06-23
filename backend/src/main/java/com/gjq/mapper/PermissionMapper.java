package com.gjq.mapper;

import com.gjq.entity.Permission;
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
public interface PermissionMapper extends BaseMapper<Permission> {

    List<Permission> selectPermissionListByUserId(Integer userId);

}
