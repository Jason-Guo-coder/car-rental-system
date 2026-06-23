package com.gjq.security;

import com.gjq.entity.Permission;
import com.gjq.entity.User;
import com.gjq.service.IPermissionService;
import com.gjq.service.IUserService;
import jakarta.annotation.Resource;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

@Component
public class CustomerUserDetailsService implements UserDetailsService {

    @Resource
    private IUserService userService;

    @Resource
    private IPermissionService permissionService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        User user = userService.selectByUsername(username);

        if (user == null){
            throw new UsernameNotFoundException("用户不存在");
        }

        //查询用户权限列表
        List<Permission> permissions = permissionService.selectPermissionListByUserId(user.getId());
        user.setPermissionList(permissions);

        //通过Stream流处理，将权限低对象转换为字符串列表
        List<String> list = permissions.stream().filter(Objects::nonNull)
                .map(Permission::getPermissionCode)
                .filter(Objects::nonNull)
                .toList();
        String[] array = list.toArray(new String[list.size()]);

        List<GrantedAuthority> authorityList= AuthorityUtils.createAuthorityList(array);
        user.setAuthorities(authorityList);

        return user;
    }
}
