package com.gjq.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoInfo;
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
public interface IAutoInfoService extends IService<AutoInfo> {

    Page searchByPage(Page<AutoInfo> page, AutoInfo autoInfo);

    AutoInfo selectByAutoNum(String autoNum);

    boolean delete(String ids);

    List<AutoInfo> toBeMaintain();
}
