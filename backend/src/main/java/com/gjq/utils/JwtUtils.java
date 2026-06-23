package com.gjq.utils;

import cn.hutool.core.date.DateTime;
import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTPayload;
import cn.hutool.jwt.JWTUtil;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * JWT 工具类。
 */
@Component
public class JwtUtils {

    /**
     * JWT 签名密钥。
     * 生成 token 和校验 token 时必须使用同一个密钥。
     */
    public static final String SECRET_KEY = "guojianquan";

    /**
     * token 过期时间，单位：毫秒。
     * 当前配置为 30 分钟。
     */
    public static final long EXPIRE_TIME = 1000L * 60 * 30;

    /**
     * 根据业务数据创建 JWT token。
     *
     * @param payload 需要写入 token 的业务数据，例如用户 id、用户名等
     * @return 生成后的 JWT token 字符串
     */
    public static String createToken(Map<String, Object> payload) {
        // 当前时间，用作 token 的签发时间和生效时间。
        DateTime now = DateTime.now();

        // 过期时间 = 当前时间 + 配置的过期毫秒数。
        DateTime expireTime = new DateTime(now.getTime() + EXPIRE_TIME);

        // token 签发时间
        payload.put(JWTPayload.ISSUED_AT, now);
        // token 过期时间
        payload.put(JWTPayload.EXPIRES_AT, expireTime);
        // token 生效时间
        payload.put(JWTPayload.NOT_BEFORE, now);

        return JWTUtil.createToken(payload, SECRET_KEY.getBytes());
    }


    /**
     * 解析并校验 JWT token。
     *
     * @param token 前端请求头中携带的 token 字符串
     * @return token 中保存的 payload 数据
     */
    public static JWTPayload parseToken(String token){
        // 先把字符串形式的 token 解析成 Hutool 的 JWT 对象。
        JWT jwt = JWTUtil.parseToken(token);

        // 使用同一个密钥校验签名，防止 token 内容被篡改。
        if (!jwt.setKey(SECRET_KEY.getBytes()).verify()){
            throw new RuntimeException("token异常");
        }

        // 校验 token 是否在有效期内，参数 0 表示不额外放宽过期时间。
        if (!jwt.validate(0)){
            throw new RuntimeException("token已过期");
        }

        // 校验通过后，返回 token 第二部分 payload 中保存的数据。
        return jwt.getPayload();
    }
}
