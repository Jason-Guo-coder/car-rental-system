package com.gjq.utils;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * 统一接口返回结果。
 *
 * @param <T> 返回数据的类型
 */
@Data
@Accessors(chain = true)
public class Result<T> {
    /**
     * 状态码，成功和失败的具体值定义在 {@link ResultCode} 中。
     */
    private Integer code;

    /**
     * 返回提示信息，例如“操作成功”或“操作失败”。
     */
    private String message;

    /**
     * 请求是否处理成功。
     */
    private Boolean success;

    /**
     * 接口返回的数据。
     */
    private T data;

    private Result(){
    }

    /**
     * 返回不带数据的成功结果。
     *
     * @param <T> 返回数据的类型
     * @return 成功结果
     */
    public static <T> Result<T> success(){
        return new Result<T>().setSuccess(true).setCode(ResultCode.SUCCESS).setMessage("操作成功");
    }

    /**
     * 返回带数据的成功结果。
     *
     * @param data 返回数据
     * @param <T> 返回数据的类型
     * @return 成功结果
     */
    public static <T> Result<T> success(T data){
        return new Result<T>().setSuccess(true).setCode(ResultCode.SUCCESS).setMessage("操作成功").setData(data);
    }

    /**
     * 返回失败结果。
     *
     * @param <T> 返回数据的类型
     * @return 失败结果
     */
    public static <T> Result<T> fail(){
        return new Result<T>().setSuccess(false).setCode(ResultCode.ERROR).setMessage("操作失败");
    }
}
