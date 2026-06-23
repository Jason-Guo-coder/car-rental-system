package com.gjq.controller;

import com.gjq.entity.User;
import com.gjq.service.IUserService;
import com.gjq.utils.Result;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

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

    @GetMapping
    public Result<List<User>> list(){
        return Result.success(userService.list());
    }

}
