package com.gjq.config;

import com.gjq.utils.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理类。
 * <p>
 * Controller 中抛出的异常会统一进入这里处理，
 * 最终返回项目统一的 {@link Result} 格式，避免前端收到不统一的错误响应。
 */
@Slf4j
@RestControllerAdvice
public class GlobalException {

    /**
     * 处理系统中的通用异常。
     *
     * @param e 捕获到的异常对象
     * @return 统一失败响应
     */
    @ExceptionHandler(value = Exception.class)
    public Result<?> handleException(Exception e){
        log.error("异常信息: {}", e.getMessage());
        log.error("异常堆栈: {}",e.toString());
        return Result.fail().setMessage(e.getMessage());
    }
}
