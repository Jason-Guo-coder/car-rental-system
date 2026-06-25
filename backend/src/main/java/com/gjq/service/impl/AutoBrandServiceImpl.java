package com.gjq.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.gjq.entity.AutoBrand;
import com.gjq.mapper.AutoBrandMapper;
import com.gjq.service.IAutoBrandService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@Service
public class AutoBrandServiceImpl extends ServiceImpl<AutoBrandMapper, AutoBrand> implements IAutoBrandService {

    @Resource
    private AutoBrandMapper autoBrandMapper;

    @Override
    public Page<AutoBrand> searchByPage(Page<AutoBrand> page, AutoBrand autoBrand) {
        return autoBrandMapper.searchByPage(page, autoBrand);
    }

    @Override
    public List<AutoBrand> selectByMakerId(Integer makerId) {
        QueryWrapper<AutoBrand> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("mid", makerId);
        return autoBrandMapper.selectList(queryWrapper);
    }
}
