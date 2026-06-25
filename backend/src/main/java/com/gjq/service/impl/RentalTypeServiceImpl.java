package com.gjq.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.RentalType;
import com.gjq.mapper.RentalTypeMapper;
import com.gjq.service.IRentalTypeService;
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
public class RentalTypeServiceImpl extends ServiceImpl<RentalTypeMapper, RentalType> implements IRentalTypeService {

    @Resource
    private RentalTypeMapper rentalTypeMapper;

    @Override
    public Object searchByPage(Page<RentalType> page, RentalType rentalType) {
        QueryWrapper<RentalType> queryWrapper = new QueryWrapper<>();

        queryWrapper.like(StrUtil.isNotEmpty(rentalType.getTypeName()), "type_name",
                rentalType.getTypeName());

        queryWrapper.le(ObjectUtils.isNotEmpty(rentalType.getHighDiscount()),"type_discount",
                rentalType.getHighDiscount());

        queryWrapper.ge(ObjectUtils.isNotEmpty(rentalType.getLowDiscount()),"type_discount",
                rentalType.getLowDiscount());

        return rentalTypeMapper.selectPage(page, queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()){
            return rentalTypeMapper.deleteBatchIds(list) > 0;
        }
        return false;
    }
}
