package com.gjq.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 全局跨域配置类。
 * <p>
 * 前后端分离时，前端项目和后端接口通常不是同一个地址或端口，
 * 浏览器会触发跨域限制，所以需要在后端统一放行跨域请求。
 */
@Configuration
public class CORSConfig implements WebMvcConfigurer {

    /**
     * 配置跨域规则。
     *
     * @param registry Spring MVC 提供的跨域配置注册器
     */
    @Override
    public void addCorsMappings(CorsRegistry registry){
        registry.addMapping("/**")
                // 允许所有来源访问接口。
                .allowedOriginPatterns("*")
                // 允许前端携带任意请求头，例如 Authorization、Content-Type。
                .allowedHeaders("*")
                // 允许所有请求方法，例如 GET、POST、PUT、DELETE。
                .allowedMethods("*")
                // 允许跨域请求携带认证信息，例如 Cookie、Authorization。
                .allowCredentials(true)
                // 预检请求缓存时间，单位是秒。
                .maxAge(3600);
    }
}
