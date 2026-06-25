package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Maintain;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IMaintainService extends IService<Maintain> {

    Page searchByPage(Page<Maintain> page, Maintain maintain);

    boolean delete(String ids);
}
