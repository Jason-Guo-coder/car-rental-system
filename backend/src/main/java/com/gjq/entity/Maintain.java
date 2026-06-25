package com.gjq.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@Getter
@Setter
@Accessors(chain = true)
@TableName("busi_maintain")
@ApiModel(value = "Maintain对象", description = "")
public class Maintain implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("保养id")
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @ApiModelProperty("车辆id")
    private Integer autoId;

    @ApiModelProperty("车牌号码")
    private String autoNum;

    @ApiModelProperty("维保时间")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate maintainTime;

    @ApiModelProperty("维保地点")
    private String location;

    @ApiModelProperty("维保项目")
    private String item;

    @ApiModelProperty("维保费用")
    private Integer cost;

    @ApiModelProperty("创建时间")
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @ApiModelProperty("更新时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @ApiModelProperty("是否删除")
    private Boolean deleted;

    @TableField(exist = false)
    private Integer lowCost;

    @TableField(exist = false)
    private Integer highCost;

    @TableField(exist = false)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lowMaintainTime;

    @TableField(exist = false)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime highMaintainTime;
}
