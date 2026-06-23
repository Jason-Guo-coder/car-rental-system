package com.gjq.controller;

import cn.hutool.core.convert.NumberWithFormat;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.util.StrUtil;
import cn.hutool.jwt.JWTPayload;
import com.gjq.entity.Permission;
import com.gjq.security.CustomerAuthenticationException;
import com.gjq.entity.User;
import com.gjq.service.IUserService;
import com.gjq.utils.JwtUtils;
import com.gjq.utils.RedisUtils;
import com.gjq.utils.Result;
import com.gjq.utils.RouteTreeUtils;
import com.gjq.vo.RouteVO;
import com.gjq.vo.TokenVO;
import com.gjq.vo.UserInfoVO;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@RestController
@RequestMapping("/rental/auth/")
public class AuthController {

    @Resource
    private RedisUtils redisUtils;

    @Resource
    private IUserService userService;

    @PostMapping("/refreshToken")
    public Result refreshToken(HttpServletRequest request){
        // 获取旧 token，优先从请求头取，取不到再从请求参数取。
        String token = request.getHeader("token");
        if (StrUtil.isEmpty(token)){
            token = request.getParameter("token");
        }

        // VerifyTokenFilter 校验通过后，会把当前登录用户放到 SecurityContextHolder。
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        // 从旧 token 中获得用户名，用来和当前登录用户做一次比对
        String username = JwtUtils.parseToken(token).getClaim("username").toString();

        String newToken = "";

        if (StrUtil.equals(username,userDetails.getUsername())){
            Map<String,Object> map = new HashMap<>();
            map.put("username",userDetails.getUsername());
            newToken = JwtUtils.createToken(map);
        } else {
            throw new CustomerAuthenticationException("token数据异常");
        }

        // 获取新 token 的过期时间。
        NumberWithFormat claim = (NumberWithFormat) JwtUtils.parseToken(newToken).getClaim(JWTPayload.EXPIRES_AT);
        DateTime dateTime = (DateTime) claim.convert(DateTime.class, claim);
        long expireTime=dateTime.getTime();

        // 返回给前端的新 token 信息
        TokenVO tokenVo = new TokenVO();
        tokenVo.setToken(newToken).setExpireTime(expireTime);

        // 删除旧 token，避免旧 token 继续使用
        redisUtils.del("token:" + token);

        // 保存新 token，并设置和 JWT 一致的剩余有效时间
        long nowTime = DateTime.now().getTime();
        String newTokenKey = "token:" + newToken;
        redisUtils.set(newTokenKey, newToken, (expireTime - nowTime) / 1000);

        return Result.success(tokenVo).setMessage("刷新token成功");
    }

    /**
     * 获取当前登录用户信息。
     * <p>
     * VerifyTokenFilter 校验 token 通过后，会把当前用户放到 SecurityContextHolder，
     * 这里再从上下文中取出用户，并查询用户角色返回给前端。
     */
    @GetMapping("/info")
    public Result getUserInfo(){
        // 从 SecurityContextHolder 上下文中获取当前认证信息。
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null){
            return Result.fail().setMessage("认证信息为空");
        }

        User user = (User) authentication.getPrincipal();
        List<String> list = userService.selectRoleName(user.getId());
        Object[] array = list.toArray();

        UserInfoVO userInfoVo = new UserInfoVO(user.getId(), user.getUsername(),
                user.getAvatar(), user.getNickname(), array);
        return Result.success(userInfoVo).setMessage("获取用户信息成功");
    }

    @GetMapping("menuList")
    public Result getMenuList(){

        //获取当前用户信息
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null){
            return Result.fail().setMessage("认证信息为空");
        }
        User user = (User) authentication.getPrincipal();

        //获取用户的权限列表
        List<Permission> permissionList = user.getPermissionList();

        //获取用户的菜单
        //将permission_type为2的按钮滤除，不需要生成对应的菜单
        permissionList.removeIf(permission -> Objects.equals(permission.getPermissionType(), 2));
        List<RouteVO> routeVOList = RouteTreeUtils.buildRouteTree(permissionList, 0);
        return Result.success(routeVOList).setMessage("获取菜单列表成功");
    }
}
