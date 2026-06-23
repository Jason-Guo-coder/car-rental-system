package com.gjq.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
public class RouteVO {
    private String path;
    private String component;
    private String name;
    private Boolean alwaysShow;

    private Meta meta;
    private List<RouteVO> children;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public class Meta{
        private String title;
        private String icon;
        private Object[] roles;
    }
}
