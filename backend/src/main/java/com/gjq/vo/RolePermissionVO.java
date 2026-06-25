package com.gjq.vo;

import com.gjq.entity.Permission;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@Accessors(chain = true)
public class RolePermissionVO {

    //原有的权限id
    private Object[] checkedList;

    private List<Permission> permissionList;
}
