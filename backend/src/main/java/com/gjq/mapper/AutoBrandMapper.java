package com.gjq.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.AutoBrand;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
public interface AutoBrandMapper extends BaseMapper<AutoBrand> {
    Page<AutoBrand> searchByPage(@Param("page") Page<AutoBrand> page, @Param("autoBrand") AutoBrand autoBrand);
}
