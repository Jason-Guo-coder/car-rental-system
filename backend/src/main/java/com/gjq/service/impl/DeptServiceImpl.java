package com.gjq.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.gjq.entity.Dept;
import com.gjq.mapper.DeptMapper;
import com.gjq.service.IDeptService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gjq.utils.DeptTreeUtils;
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
public class DeptServiceImpl extends ServiceImpl<DeptMapper, Dept> implements IDeptService {

    @Override
    public List<Dept> selectList(Dept dept) {
        QueryWrapper<Dept> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(StrUtil.isNotEmpty(dept.getDeptName()),"dept_name",dept.getDeptName());
        queryWrapper.orderByAsc("order_num");
        List<Dept> deptList = baseMapper.selectList(queryWrapper); //不包含子部门

        //查询每个部门的子部门  --->   DeptTreeUtil
        return DeptTreeUtils.buildTree(deptList,0);

    }

    @Override
    public List<Dept> selectTree() {
        QueryWrapper<Dept> queryWrapper=new QueryWrapper<>();
        queryWrapper.orderByAsc("order_num");
        List<Dept> depts = baseMapper.selectList(queryWrapper);
        Dept dept=new Dept();
        dept.setDeptName("所有部门").setId(0).setPid(-1);
        depts.add(dept);
        return DeptTreeUtils.buildTree(depts,-1);
    }

    @Override
    public boolean hasChildren(Integer deptId) {
        QueryWrapper<Dept> queryWrapper = new QueryWrapper<>();
        // 查有没有别的部门把当前部门 deptId 当成上级部门。
        queryWrapper.eq("pid",deptId);
        return baseMapper.selectCount(queryWrapper) > 0;
    }

}
