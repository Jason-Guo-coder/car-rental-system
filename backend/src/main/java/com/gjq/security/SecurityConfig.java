package com.gjq.security;

import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Resource
    private LoginSuccessHandler loginSuccessHandler;

    @Resource
    private LoginFailHandler loginFailHandler;

    @Resource
    private CustomerAccessDeniedHandler customerAccessDeniedHandler;

    @Resource
    private CustomerAnonymousEntryPoint customerAnonymousEntryPoint;

    @Resource
    private CustomerUserDetailsService customerUserDetailsService;

    @Value("${request.login-url}")
    private String loginUrl;

    @Resource
    private VerifyTokenFilter verifyTokenFilter;

    /**
     * 配置安全过滤链
     *
     * @param http 用于配置HttpSecurity的接口
     * @return 返回构建好的SecurityFilterChain对象
     * @throws Exception 如果配置过程中发生错误，则抛出异常
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http)
            throws Exception{

        //登录前校验
        http.addFilterBefore(verifyTokenFilter, UsernamePasswordAuthenticationFilter.class);

        // 设置用户详情服务：登录时先用它根据用户名查询数据库用户。
        http.userDetailsService(customerUserDetailsService)
                // 登录配置
                .formLogin()
                .loginProcessingUrl(loginUrl) // 设置登录处理URL
                .successHandler(loginSuccessHandler) // 设置登录成功处理器
                .failureHandler(loginFailHandler) // 设置登录失败处理器
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS) // 表示不使用服务器 session
                .and()
                .authorizeHttpRequests() // 授权请求配置
                .requestMatchers(loginUrl) // 匹配登录请求
                .permitAll() // 允许所有请求访问
                .anyRequest().authenticated() // 任何其他请求需要认证
                .and()
                .exceptionHandling() // 异常处理配置
                .authenticationEntryPoint(customerAnonymousEntryPoint) // 设置未认证入口点
                .accessDeniedHandler(customerAccessDeniedHandler) // 设置访问拒绝处理器
                .and()
                .cors() // 跨域配置
                .and()
                .csrf().disable(); // 关闭CSRF保护  跨站请求伪造 是一种网络攻击
        return http.build(); // 构建并返回安全过滤链

    }
}
