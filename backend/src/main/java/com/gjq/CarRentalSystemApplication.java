package com.gjq;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("com.gjq.mapper")
@SpringBootApplication
public class CarRentalSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(CarRentalSystemApplication.class, args);
    }
}
