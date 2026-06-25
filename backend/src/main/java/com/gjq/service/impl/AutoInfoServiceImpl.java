package com.gjq.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.gjq.entity.AutoInfo;
import com.gjq.mapper.AutoInfoMapper;
import com.gjq.service.IAutoInfoService;
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
public class AutoInfoServiceImpl extends ServiceImpl<AutoInfoMapper, AutoInfo> implements IAutoInfoService {

    @Resource
    private AutoInfoMapper autoInfoMapper;

    @Override
    public Page searchByPage(Page<AutoInfo> page, AutoInfo autoInfo) {
        return autoInfoMapper.searchByPage(page,autoInfo);
    }

    @Override
    public AutoInfo selectByAutoNum(String autoNum) {
        QueryWrapper<AutoInfo> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("auto_num", autoNum);
        return autoInfoMapper.selectOne(queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        if (!list.isEmpty()){
            return autoInfoMapper.deleteBatchIds(list) > 0;
        }
        return false;
    }

    @Override
    public List<AutoInfo> toBeMaintain() {
        return autoInfoMapper.toBeMaintain();
    }
}
