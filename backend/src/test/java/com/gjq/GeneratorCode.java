package com.gjq;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import org.junit.jupiter.api.Test;

import java.util.Collections;

public class GeneratorCode {

    private static final String AUTHOR = "guojianquan";
    private static final String JDBC_URL = "jdbc:mysql://127.0.0.1:3306/car_rental_system?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String JDBC_USERNAME = System.getenv().getOrDefault("MYSQL_USERNAME", "root");
    private static final String JDBC_PASSWORD = System.getenv().getOrDefault("MYSQL_PASSWORD", "");
    private static final String PROJECT_PATH = System.getProperty("user.dir");
    private static final String OUT_DIR = PROJECT_PATH + "/src/main/java";
    private static final String XML_OUT_DIR = PROJECT_PATH + "/src/main/resources/mapper";
    private static final String PACKAGE_NAME = "com.gjq";
    private static final String[] TABLES = {
            "auto_brand",
            "auto_info",
            "auto_maker",
            "busi_customer",
            "busi_maintain",
            "busi_order",
            "busi_rental_type",
            "busi_violation",
            "sys_dept",
            "sys_permission",
            "sys_role",
            "sys_role_permission",
            "sys_user",
            "sys_user_role"
    };
    private static final String[] PREFIX = {"busi_", "sys_"};

    @Test
    void generatorCode() {
        FastAutoGenerator.create(JDBC_URL, JDBC_USERNAME, JDBC_PASSWORD)
                .globalConfig(builder -> builder
                        .author(AUTHOR)
                        .enableSwagger()
                        .outputDir(OUT_DIR))
                .packageConfig(builder -> builder
                        .parent(PACKAGE_NAME)
                        .pathInfo(Collections.singletonMap(OutputFile.xml, XML_OUT_DIR)))
                .strategyConfig(builder -> builder
                        .addInclude(TABLES)
                        .addTablePrefix(PREFIX)
                        .entityBuilder()
                        .enableLombok()
                        .enableChainModel()
                        .controllerBuilder()
                        .enableRestStyle())
                .templateEngine(new FreemarkerTemplateEngine())
                .execute();
    }
}
