package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoBrand;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IAutoBrandService extends IService<AutoBrand> {
    Page<AutoBrand> searchByPage(Page<AutoBrand> page, AutoBrand autoBrand);
}
