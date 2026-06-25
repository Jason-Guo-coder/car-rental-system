package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Violation;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IViolationService extends IService<Violation> {

    Page searchByPage(Page<Violation> page, Violation violation);

    boolean delete(String ids);
}
