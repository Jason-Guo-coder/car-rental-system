package com.gjq.security;

import cn.hutool.core.util.StrUtil;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 8.6 使用的明文密码编码器。
 * <p>
 * 8.8 已经改用 {@link PasswordConfig} 中的 BCryptPasswordEncoder，
 * 所以这里不再注册为 Spring Bean，只保留作为学习对照。
 */
public class CustomerPasswordEncoder implements PasswordEncoder {
    @Override
    public String encode(CharSequence rawPassword) {
        return rawPassword.toString();
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        return StrUtil.equals(encode(rawPassword),encodedPassword);
    }
}
