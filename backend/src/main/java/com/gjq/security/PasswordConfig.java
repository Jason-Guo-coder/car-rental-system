package com.gjq.security;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.SecureRandom;

@Configuration
@Data
public class PasswordConfig {

    @Value("${encoder.ctype.strength}")
    private int strength;

    @Value("${encoder.ctype.secret}")
    private String secret;

    /**
     * BCrypt 密码编码器。
     * <p>
     * Spring Security 登录时会用它加密和校验密码。
     */
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        SecureRandom secureRandom = new SecureRandom(secret.getBytes());
        return new BCryptPasswordEncoder(strength, secureRandom);
    }
}
