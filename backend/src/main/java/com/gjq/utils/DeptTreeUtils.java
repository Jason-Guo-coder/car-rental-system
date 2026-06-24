package com.gjq.utils;

import com.gjq.entity.Dept;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.List;

public class DeptTreeUtils {
    /**
     * 把平铺的部门列表整理成树形结构。
     *
     * @param deptList 所有部门数据，来自数据库查询结果
     * @param parentId 当前要查找的父部门 id，第一次调用一般传 0
     * @return 当前父部门下面的子部门列表，每个子部门里还会继续带 children
     */
    public static List<Dept> buildTree(List<Dept> deptList, int parentId) {
        List<Dept> treeList = new ArrayList<>();

        // 如果部门列表为空，则说明数据库没有查到部门数据，直接返回空树。
        if (deptList == null || deptList.isEmpty()) {
            return treeList;
        }

        for (Dept dept : deptList) {
            // 如果当前部门为空，或者没有上级部门 id，则说明这条数据不完整，跳过不处理。
            if (dept == null || dept.getPid() == null) {
                continue;
            }

            // 如果当前部门的 pid 不等于 parentId，则说明它不是当前父部门的直属子部门，跳过。
            if (!dept.getPid().equals(parentId)) {
                continue;
            }

            Dept treeNode = new Dept();
            BeanUtils.copyProperties(dept, treeNode);

            // 递归查找当前部门下面的子部门。
            List<Dept> children = buildTree(deptList, dept.getId());
            treeNode.setChildren(children);

            treeList.add(treeNode);
        }

        return treeList;
    }
}
