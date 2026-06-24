package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoMaker;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface IAutoMakerService extends IService<AutoMaker> {

    Page<AutoMaker> search(int start, int size, AutoMaker autoMaker);
}
