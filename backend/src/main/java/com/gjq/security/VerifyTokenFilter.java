package com.gjq.security;

import cn.hutool.core.util.StrUtil;
import com.gjq.utils.JwtUtils;
import com.gjq.utils.RedisUtils;
import jakarta.annotation.Resource;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * token 校验过滤器。
 * <p>
 * 除登录接口外，其他请求都需要携带 token。
 */
@Component
public class VerifyTokenFilter extends OncePerRequestFilter {

    @Value("${request.login-url}")
    private String loginUrl;

    /**
     * 用来从 Redis 中读取登录成功后保存的 token。
     */
    @Resource
    private RedisUtils redisUtils;

    /**
     * 用来根据 token 中的 username 重新查询用户信息和权限。
     */
    @Resource
    private CustomerUserDetailsService customerUserDetailsService;

    /**
     * token 校验失败时，复用登录失败处理器返回统一 JSON。
     */
    @Resource
    private LoginFailHandler loginFailHandler;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        // 当前请求路径。
        String url = request.getRequestURI();

        // 登录接口本身不需要 token，其他接口都需要先校验 token。
        if (!StrUtil.equals(url, loginUrl)) {
            try {
                validateToken(request, response);
            } catch (AuthenticationException e) {
                // token 校验失败，直接返回失败 JSON，不再继续往后访问 Controller。
                loginFailHandler.onAuthenticationFailure(request, response, e);
                return;
            }
        }

        // token 校验通过，继续执行后面的过滤器或 Controller。
        filterChain.doFilter(request, response);
    }

    /**
     * 校验请求中携带的 token 是否有效。
     */
    private void validateToken(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        // 优先从请求头获取 token。
        String token = request.getHeader("token");
        if (StrUtil.isEmpty(token)){
            // 如果请求头没有 token，再从请求参数中获取。
            token = request.getParameter("token");
        }
        if (StrUtil.isEmpty(token)){
            throw new CustomerAuthenticationException("token为空");
        }

        // 登录成功时 Redis 中保存的 key 格式是 token:具体token值。
        String tokenKey = "token:" + token;
        String tokenValue = redisUtils.get(tokenKey);
        if (StrUtil.isEmpty(tokenValue)) {
            // Redis 中没有这个 token，说明 token 已过期或已经被删除。
            throw new CustomerAuthenticationException("token已过期");
        }

        if (!StrUtil.equals(token, tokenValue)) {
            // 请求中的 token 和 Redis 保存的 token 不一致。
            throw new CustomerAuthenticationException("token错误");
        }

        // 从 JWT 中解析用户名。
        String username = JwtUtils.parseToken(token).getClaim("username").toString();
        if (StrUtil.isEmpty(username)) {
            throw new CustomerAuthenticationException("token解析失败");
        }

        // 根据用户名重新加载用户信息和权限。
        UserDetails userDetails = customerUserDetailsService.loadUserByUsername(username);
        if (userDetails == null) {
            throw new CustomerAuthenticationException("用户不存在");
        }

        // 创建 Spring Security 认证对象，表示当前请求已经通过认证。
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        // 把认证信息放入SpringSecurityHolder上下文
        SecurityContextHolder.getContext().setAuthentication(authenticationToken);
    }
}
