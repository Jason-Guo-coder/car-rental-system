package com.gjq.utils;

import com.gjq.entity.Permission;
import com.gjq.vo.RouteVO;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RouteTreeUtils {

    /**
     * 根据权限列表生成前端需要的路由菜单树。
     *
     * @param permissionList 当前用户拥有的权限菜单列表
     * @param pid            父级权限 id，第一次调用时传 0，表示从顶级菜单开始生成
     * @return 前端可以直接使用的路由菜单列表
     */
    public static List<RouteVO> buildRouteTree(List<Permission> permissionList, int pid) {
        List<RouteVO> routeVoList = new ArrayList<>();

        // 从权限列表中找出 pid 等于当前 pid 的菜单，作为当前层级的菜单。
        Optional.ofNullable(permissionList).orElse(new ArrayList<>())
                .stream()
                .filter(permission -> permission != null && permission.getPid() == pid)
                .forEach(permission -> {
                    RouteVO routeVo = new RouteVO();
                    routeVo.setPath(permission.getRoutePath()); // 前端路由地址
                    routeVo.setName(permission.getRouteName()); // 前端路由名称

                    // 顶级菜单使用 Layout 组件；子菜单使用数据库中配置的页面组件路径。
                    if (permission.getPid() == 0) {
                        routeVo.setComponent("Layout");
                        routeVo.setAlwaysShow(true);
                    } else {
                        routeVo.setComponent(permission.getRouteUrl());
                        routeVo.setAlwaysShow(false);
                    }

                    // meta 是前端菜单显示需要的信息：标题、图标、权限标识。
                    routeVo.setMeta(routeVo.new Meta(permission.getPermissionLable(),
                            permission.getIcon(),
                            permission.getPermissionCode().split(",")));

                    // 递归生成当前菜单下面的子菜单。
                    List<RouteVO> children = buildRouteTree(permissionList, permission.getId());
                    routeVo.setChildren(children);
                    routeVoList.add(routeVo);
                });

        return routeVoList;
    }

    public static List<Permission> buildMenuTree(List<Permission> list,int parentId){
        List<Permission> menuList = new ArrayList<>();

        // 如果权限列表为空，则说明数据库没有查到菜单数据，直接返回空树。
        if (list == null || list.isEmpty()) {
            return menuList;
        }

        for (Permission permission : list) {
            // 如果当前权限为空，或者没有父级权限 id，则说明这条数据不完整，跳过不处理。
            if (permission == null || permission.getPid() == null) {
                continue;
            }

            // 如果当前权限的 pid 不等于 parentId，则说明它不是当前父级菜单的直属子菜单，跳过。
            if (!permission.getPid().equals(parentId)) {
                continue;
            }

            Permission menu = new Permission();
            BeanUtils.copyProperties(permission, menu);

            // 递归查找当前菜单下面的子菜单。
            List<Permission> children = buildMenuTree(list, permission.getId());
            menu.setChildren(children);

            menuList.add(menu);
        }

        return menuList;

    }
}
