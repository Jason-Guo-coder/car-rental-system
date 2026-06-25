package com.gjq.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoInfo;
import com.gjq.entity.Maintain;
import com.gjq.mapper.AutoInfoMapper;
import com.gjq.mapper.MaintainMapper;
import com.gjq.service.IMaintainService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Arrays;
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
public class MaintainServiceImpl extends ServiceImpl<MaintainMapper, Maintain> implements IMaintainService {

    @Resource
    private AutoInfoMapper autoInfoMapper;

    @Resource
    private MaintainMapper maintainMapper;

    @Override
    public Page searchByPage(Page<Maintain> page, Maintain maintain) {
        QueryWrapper<Maintain> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(ObjectUtil.isNotEmpty(maintain.getAutoNum()),
                "auto_num", maintain.getAutoNum());
        queryWrapper.like(ObjectUtil.isNotEmpty(maintain.getItem()),
                "item", maintain.getItem());
        queryWrapper.like(ObjectUtil.isNotEmpty(maintain.getLocation()),
                "location", maintain.getLocation());
        queryWrapper.le(ObjectUtil.isNotEmpty(maintain.getHighMaintainTime()),
                "maintain_time", maintain.getHighMaintainTime());
        queryWrapper.ge(ObjectUtil.isNotEmpty(maintain.getLowMaintainTime()),
                "maintain_time", maintain.getLowMaintainTime());
        queryWrapper.le(ObjectUtil.isNotEmpty(maintain.getHighCost()),
                "cost", maintain.getHighCost());
        queryWrapper.ge(ObjectUtil.isNotEmpty(maintain.getLowCost()),
                "cost", maintain.getLowCost());
        queryWrapper.orderByDesc("maintain_time");
        return baseMapper.selectPage(page,queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()){
            list.forEach(id -> {
                Maintain maintain = maintainMapper.selectById(id);
                if (ObjectUtil.isNotEmpty(maintain)){
                    Integer autoId = maintain.getAutoId();
                    AutoInfo autoInfo=autoInfoMapper.selectById(autoId);
                    autoInfo.setActualNum(autoInfo.getActualNum()-1);
                    autoInfoMapper.updateById(autoInfo);
                }
            });
            return baseMapper.deleteBatchIds(list) > 0;
        }
        return false;
    }
}
