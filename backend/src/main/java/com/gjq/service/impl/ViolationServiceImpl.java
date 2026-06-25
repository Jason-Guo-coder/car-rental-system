package com.gjq.service.impl;

import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.Violation;
import com.gjq.mapper.ViolationMapper;
import com.gjq.service.IViolationService;
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
public class ViolationServiceImpl extends ServiceImpl<ViolationMapper, Violation> implements IViolationService {

    @Resource
    private ViolationMapper violationMapper;

    @Override
    public Page searchByPage(Page<Violation> page, Violation violation) {
        QueryWrapper<Violation> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(ObjectUtil.isNotEmpty(violation.getAutoNum()),
                "auto_num",violation.getAutoNum());
        queryWrapper.like(ObjectUtil.isNotEmpty(violation.getReason()),
                "reason",violation.getReason());
        queryWrapper.like(ObjectUtil.isNotEmpty(violation.getLocation()),
                "location",violation.getLocation());
        queryWrapper.le(ObjectUtil.isNotEmpty(violation.getHighViolationTime()),
                "violation_time",violation.getHighViolationTime());
        queryWrapper.ge(ObjectUtil.isNotEmpty(violation.getLowViolationTime()),
                "violation_time",violation.getLowViolationTime());
        queryWrapper.le(ObjectUtil.isNotEmpty(violation.getHighFine()),
                "fine",violation.getHighFine());
        queryWrapper.ge(ObjectUtil.isNotEmpty(violation.getLowFine()),
                "fine",violation.getLowFine());
        queryWrapper.eq(ObjectUtil.isNotEmpty(violation.getStatus()),
                "status",violation.getStatus());
        queryWrapper.orderByDesc("violation_time");
        return baseMapper.selectPage(page,queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()){
            return violationMapper.deleteBatchIds(list) > 0;
        }
        return false;
    }
}
