package com.gjq.service.impl;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.gjq.entity.User;
import com.gjq.entity.UserRole;
import com.gjq.mapper.UserMapper;
import com.gjq.mapper.UserRoleMapper;
import com.gjq.service.IUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author guojianquan
 * @since 2026-06-22
 */
@Service
@Transactional
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Resource
    private UserMapper userMapper;

    @Resource
    private UserRoleMapper userRoleMapper;

    @Resource
    private OssServiceImpl ossService;

    @Override
    public User selectByUsername(String username) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username",username);
        return userMapper.selectOne(queryWrapper);
    }

    @Override
    public List<String> selectRoleName(int id) {
        return userMapper.selectRoleNameByUserId(id);
    }

    @Override
    public Page<User> searchByPage(Page<User> page, User user) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        if (user.getDeptId()!=null && user.getDeptId()==0){
            return userMapper.selectPage(page,null);
        }
        queryWrapper.eq(ObjectUtil.isNotEmpty(user.getDeptId()),"dept_id",user.getDeptId());
        queryWrapper.like(StrUtil.isNotBlank(user.getUsername()),"username",user.getUsername());
        queryWrapper.like(StrUtil.isNotBlank(user.getRealname()),"realname",user.getRealname());
        queryWrapper.like(StrUtil.isNotBlank(user.getNickname()),"nickname",user.getNickname());
        queryWrapper.like(StrUtil.isNotBlank(user.getPhone()),"phone",user.getPhone());
        queryWrapper.like(StrUtil.isNotBlank(user.getEmail()),"email",user.getEmail());

        return userMapper.selectPage(page,queryWrapper);
    }

    @Override
    public boolean delete(String ids) {
        List<Integer> list = Arrays.stream(ids.split(",")).map(Integer::parseInt).toList();
        try {
            if (!list.isEmpty()) {
                list.forEach(id -> {
                    User user = userMapper.selectById(id);
                    if (user.getIsAdmin() != null && user.getIsAdmin() != 1) {
                        //删除时，要同时删除用户的头像
                        if (user.getAvatar()!=null){
                            ossService.delete(user.getAvatar());
                        }
                        //删除用户
                        userMapper.deleteById(id);
                        //删除用户和角色关联表数据
                        userRoleMapper.delete(new QueryWrapper<UserRole>().eq("user_id", id));
                    }
                });
            }
            return true;

        } catch (Exception e) {
            throw new RuntimeException("删除失败");
        }
    }

    @Override
    public boolean bindRole(Integer userId, List<Integer> list) {
        //先删除所有当前用户和角色的关联
        userRoleMapper.delete(new QueryWrapper<UserRole>().eq("user_id", userId));
        //重新插入用户和角色关联
        if (!list.isEmpty()){
            list.forEach(roleId -> {
                UserRole userRole = new UserRole();
                userRole.setUserId(userId);
                userRole.setRoleId(roleId);
                userRoleMapper.insert(userRole);
            });
            return true;
        }
        return false;
    }
}
