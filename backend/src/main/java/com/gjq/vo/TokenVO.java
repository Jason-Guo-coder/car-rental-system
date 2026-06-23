package com.gjq.vo;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class TokenVO {
    private String token;
    private Long expireTime;
}
