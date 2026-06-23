package com.gjq.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * MyBatis-Plus 自动填充处理器。
 */
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    /**
     * 新增数据时自动填充创建时间和修改时间。
     *
     * @param metaObject MyBatis-Plus 当前操作的实体对象
     */
    @Override
    public void insertFill(MetaObject metaObject) {
        this.strictInsertFill(metaObject, "createTime", LocalDateTime::now, LocalDateTime.class);
        this.strictInsertFill(metaObject, "updateTime", LocalDateTime::now, LocalDateTime.class);
    }

    /**
     * 修改数据时自动填充修改时间。
     *
     * @param metaObject MyBatis-Plus 当前操作的实体对象
     */
    @Override
    public void updateFill(MetaObject metaObject) {
        this.strictUpdateFill(metaObject, "updateTime", LocalDateTime::now, LocalDateTime.class);
    }
}
