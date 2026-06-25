package com.gjq.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.User;
import com.gjq.service.IRoleService;
import com.gjq.service.IUserService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Stream;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@RestController
@RequestMapping("/rental/user")
public class UserController {

    @Resource
    private IUserService userService;

    @Resource
    private PasswordEncoder passwordEncoder;

    @Resource
    private IRoleService roleService;

    @GetMapping
    public Result<List<User>> list(){
        return Result.success(userService.list());
    }

    @PostMapping("/{start}/{size}")
    public Result search(@PathVariable int start, @PathVariable int size, @RequestBody User user) {
        return Result.success(userService.searchByPage(new Page<>(start, size), user));
    }

    @PostMapping
    public Result save(@RequestBody User user){
        User user1 = userService.selectByUsername(user.getUsername());
        if (user1 != null) {
            return Result.fail().setMessage("用户名已存在");
        }
        else {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            user.setIsAdmin(0);
            if (StrUtil.isEmpty(user.getAvatar())) {
                user.setAvatar("https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif");
            }
            return userService.save(user) ? Result.success() : Result.fail();
        }
    }

    @PutMapping
    public Result update(@RequestBody User user) {
        User u = userService.selectByUsername(user.getUsername());
        if (u != null && !Objects.equals(u.getId(), user.getId())) {
            return Result.fail().setMessage("用户名已存在");
        }
        if (StrUtil.isEmpty(user.getAvatar())) {
            user.setAvatar("https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif");
        }
        return userService.updateById(user) ? Result.success() : Result.fail();
    }

    @DeleteMapping("{ids}")
    public Result delete(@PathVariable String ids) {
        return userService.delete(ids) ? Result.success() : Result.fail();
    }

    //获取当前用户所绑定的角色id
    @GetMapping("/role/{userId}")
    public Result selectRoleByUserId(@PathVariable Integer userId){
        return Result.success(roleService.selectRoleIdByUserId(userId));
    }

    @GetMapping("/bind/{userId}/{roleIds}")
    public Result bindRole(@PathVariable Integer userId , @PathVariable String roleIds) {
        List<Integer> list = Arrays.stream(roleIds.split(",")).map(Integer::parseInt).toList();
        return userService.bindRole(userId, list) ? Result.success() : Result.fail();
    }
}
