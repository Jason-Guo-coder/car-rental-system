package com.gjq.security;

import com.alibaba.fastjson.JSON;
import com.gjq.utils.Result;
import com.gjq.utils.ResultCode;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Component
public class LoginFailHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {

        response.setContentType("application/json;charset=utf-8");
        ServletOutputStream outputStream = response.getOutputStream();

        int code = ResultCode.ERROR;
        String msg = null;

        // 根据 Spring Security 抛出的不同异常，返回更明确的登录失败原因。
        if (exception instanceof AccountExpiredException) {
            code = ResultCode.UNAUTHENTICATED;
            msg = "账户过期";
        } else if (exception instanceof BadCredentialsException) {
            code = ResultCode.UNAUTHENTICATED;
            msg = "账户或密码错误";
        } else if (exception instanceof CredentialsExpiredException) {
            code = ResultCode.UNAUTHENTICATED;
            msg = "密码过期";
        } else if (exception instanceof DisabledException) {
            code = ResultCode.UNAUTHORIZED;
            msg = "账户被禁用";
        } else if (exception instanceof LockedException) {
            code = ResultCode.UNAUTHORIZED;
            msg = "账户被锁定";
        } else if (exception instanceof InternalAuthenticationServiceException) {
            code = ResultCode.UNAUTHENTICATED;
            msg = "账户不存在";
        } else if (exception instanceof CustomerAuthenticationException) {
            code = ResultCode.UNAUTHORIZED;
            msg = exception.getMessage();
        } else {
            msg = "登录失败";
        }

        String result = JSON.toJSONString(Result.fail().setCode(code).setMessage(msg));
        outputStream.write(result.getBytes(StandardCharsets.UTF_8));
        outputStream.flush();
        outputStream.close();

    }
}
