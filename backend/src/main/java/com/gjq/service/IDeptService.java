package com.gjq.service;

import com.gjq.entity.Dept;
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
public interface IDeptService extends IService<Dept> {
    List<Dept> selectList(Dept dept);

    List<Dept> selectTree();

    boolean hasChildren(Integer id);
}
