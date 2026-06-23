package com.gjq.security;

import org.springframework.security.core.AuthenticationException;

/**
 * 自定义认证异常。
 * <p>
 * 后面校验 token、刷新 token 时，可以抛出这个异常，
 * 再由登录失败处理器或认证入口统一返回 JSON 错误信息。
 */
public class CustomerAuthenticationException extends AuthenticationException {

    public CustomerAuthenticationException(String msg) {
        super(msg);
    }
}
