<template>
  <div class="app-container">
    <el-container :style="{ height: containerHeight + 'px' }">
      <!-- 左侧部门树 -->
      <el-aside width="200px" class="el-aside">
        <el-tree
          :data="treeData"
          :props="defaultProps"
          node-key="id"
          empty-text="暂无数据"
          :default-expand-all="true"
          :highlight-current="true"
          @node-click="handleNodeClick"
        />
      </el-aside>

      <el-main style="padding: 0 0 0 10px;">
        <!-- 查询表单 -->
        <el-form :inline="true" :model="userModel" size="small" style="margin: 5px;">
          <el-form-item>
            <el-input v-model="userModel.username" placeholder="用户账号" style="width: 150px;" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="userModel.realname" placeholder="真实姓名" style="width: 150px;" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="userModel.nickname" placeholder="用户昵称" style="width: 150px;" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="userModel.phone" placeholder="联系电话" style="width: 150px;" />
          </el-form-item>
          <el-form-item>
            <el-input v-model="userModel.email" placeholder="电子邮箱" style="width: 150px;" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
            <el-button type="danger" icon="el-icon-refresh" @click="handleReset">重置</el-button>
            <el-button v-if="hasPermission('sys:user:add')" type="success" icon="el-icon-plus" @click="handleAdd">新增</el-button>
            <el-button v-if="hasPermission('sys:user:deleteBatch')" type="warning" icon="el-icon-delete" @click="handleDeleteBatch">删除选中</el-button>
          </el-form-item>
        </el-form>

        <!-- 表格数据 -->
        <el-table :data="tableData" border stripe style="width: 100%;" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="40" />
          <el-table-column label="序号" width="60">
            <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
          </el-table-column>
          <el-table-column prop="username" label="用户账号" width="90" />
          <el-table-column prop="realname" label="真实姓名" width="90" />
          <el-table-column prop="nickname" label="用户昵称" width="100" />
          <el-table-column prop="phone" label="用户电话" width="120" />
          <el-table-column prop="gender" label="用户性别" width="80">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.gender === 1" type="success">男</el-tag>
              <el-tag v-else type="danger">女</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="deptName" label="所在部门" width="150" />
          <el-table-column prop="email" label="电子邮箱" width="150" />
          <el-table-column prop="avatar" label="用户头像" width="90">
            <template slot-scope="scope">
              <el-image
                v-if="scope.row.avatar"
                :src="scope.row.avatar"
                :preview-src-list="[scope.row.avatar]"
                fit="cover"
                style="width: 50px; height: 50px;"
              />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="260">
            <template slot-scope="scope">
              <el-button v-if="hasPermission('sys:user:edit')" type="primary" icon="el-icon-edit" size="mini" @click="handleEdit(scope.row)">编辑</el-button>
              <el-button v-if="hasPermission('sys:user:delete')" type="danger" icon="el-icon-delete" size="mini" @click="handleDelete(scope.row)">删除</el-button>
              <el-button type="success" icon="el-icon-s-custom" size="mini" @click="handleRole(scope.row)">绑定角色</el-button>
            </template>
          </el-table-column>
        </el-table>

        <el-pagination
          :current-page="start"
          background
          :page-size="size"
          layout="total, prev, pager, next, jumper"
          :total="total"
          @current-change="search"
        />
      </el-main>
    </el-container>

    <!-- 新增/修改弹窗 -->
    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogVisible" width="40%">
      <el-form ref="form" :model="saveUser" :rules="rules" label-width="80px" :inline="true">
        <el-form-item label="所在部门" prop="deptName">
          <el-input ref="deptName" v-model="saveUser.deptName" :readonly="true" @click.native="openDeptSelect" />
        </el-form-item>
        <el-form-item label="用户账号" prop="username">
          <el-input v-model="saveUser.username" placeholder="请输入用户账号" />
        </el-form-item>
        <el-form-item v-if="dialogStatus === 'create'" label="用户密码" prop="password">
          <el-input v-model="saveUser.password" placeholder="请输入用户密码" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="realname">
          <el-input v-model="saveUser.realname" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="用户昵称" prop="nickname">
          <el-input v-model="saveUser.nickname" placeholder="请输入用户昵称" />
        </el-form-item>
        <el-form-item label="用户电话" prop="phone">
          <el-input v-model="saveUser.phone" placeholder="请输入用户电话" />
        </el-form-item>
        <el-form-item label="电子邮箱" prop="email">
          <el-input v-model="saveUser.email" placeholder="请输入电子邮箱" />
        </el-form-item>
        <el-form-item label="用户性别" prop="gender">
          <el-radio-group v-model="saveUser.gender">
            <el-radio-button :label="1">男</el-radio-button>
            <el-radio-button :label="2">女</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="用户头像" prop="avatar">
          <el-upload
            class="avatar-uploader"
            :action="uploadPath"
            :headers="uploadToken"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <img v-if="saveUser.avatar" :src="saveUser.avatar" class="avatar">
            <i v-else class="el-icon-plus avatar-uploader-icon" />
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 选择部门树 -->
    <el-dialog title="选择部门" :visible.sync="dialogDeptVisible" width="30%">
      <el-tree
        ref="tree"
        :data="treeData"
        :props="defaultProps"
        node-key="id"
        empty-text="暂无数据"
        :default-expand-all="true"
        :expand-on-click-node="false"
        @node-click="handleDeptSelect"
      />
      <div slot="footer" class="dialog-footer">
        <el-button @click="clearSelect">取 消</el-button>
        <el-button type="primary" @click="handleDeptConfirm">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 角色绑定弹窗 -->
    <el-dialog title="角色绑定" :visible.sync="dialogRoleVisible" width="30%">
      <el-checkbox-group v-model="roleIds">
        <el-checkbox v-for="item in roleList" :key="item.id" :label="item.id">{{ item.roleName }}</el-checkbox>
      </el-checkbox-group>
      <div slot="footer" class="dialog-footer">
        <el-button @click="clearBind">取 消</el-button>
        <el-button type="primary" @click="handleBindRole">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import userApi from '@/api/user'
import roleApi from '@/api/role'
import deptApi from '@/api/dept'
import { getToken } from '@/utils/auth'

export default {
  name: 'UserList',
  data() {
    return {
      containerHeight: window.innerHeight - 110,
      userModel: {},
      tableData: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      treeData: [],
      defaultProps: {
        children: 'children',
        label: 'deptName'
      },
      dialogVisible: false,
      dialogDeptVisible: false,
      dialogRoleVisible: false,
      dialogStatus: 'create',
      saveUser: {},
      selectedDept: {},
      roleList: [],
      roleIds: [],
      bindUserId: null,
      uploadPath: process.env.VUE_APP_BASE_API + 'rental/oss/upload',
      uploadToken: { token: getToken() },
      titleMap: {
        create: '新增用户',
        update: '修改用户'
      },
      rules: {
        deptName: [
          { required: true, message: '请选择所在部门', trigger: 'change' }
        ],
        username: [
          { required: true, message: '请输入用户账号', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入用户密码', trigger: 'blur' }
        ],
        realname: [
          { required: true, message: '请输入真实姓名', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadDeptTree()
    this.search()
  },
  methods: {
    async loadDeptTree() {
      const res = await deptApi.selectTree()
      if (res.success) {
        this.treeData = res.data
      }
    },
    async search(start = 1) {
      this.start = start
      const res = await userApi.search(this.start, this.size, this.userModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      this.search(1)
    },
    handleNodeClick(data) {
      this.userModel.deptId = data.id
      this.search()
    },
    handleReset() {
      this.userModel = {}
      this.tableData = []
      this.search()
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    handleAdd() {
      this.dialogStatus = 'create'
      this.dialogVisible = true
      this.saveUser = {}
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleEdit(row) {
      this.dialogStatus = 'update'
      this.dialogVisible = true
      this.saveUser = { ...row }
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    // 打开部门选择树
    openDeptSelect() {
      this.dialogDeptVisible = true
    },
    handleDeptSelect(data) {
      this.selectedDept = data
    },
    handleDeptConfirm() {
      this.$set(this.saveUser, 'deptId', this.selectedDept.id)
      this.$set(this.saveUser, 'deptName', this.selectedDept.deptName)
      this.dialogDeptVisible = false
    },
    clearSelect() {
      this.dialogDeptVisible = false
      this.selectedDept = {}
    },
    // 打开角色绑定弹窗
    handleRole(row) {
      this.bindUserId = row.id
      this.dialogRoleVisible = true
      // 获取所有角色列表
      roleApi.list().then(res => {
        if (res.success) {
          this.roleList = res.data
        }
      })
      // 获取用户已绑定的角色
      userApi.selectRoleIdByUserId(row.id).then(res => {
        if (res.success) {
          this.roleIds = res.data
        }
      })
    },
    handleBindRole() {
      userApi.bindRole(this.bindUserId, this.roleIds).then(res => {
        if (res.success) {
          this.$message({
            message: '角色绑定成功',
            type: 'success'
          })
          this.dialogRoleVisible = false
        }
      })
    },
    clearBind() {
      this.dialogRoleVisible = false
      this.roleIds = []
    },
    // 上传头像成功
    handleAvatarSuccess(res, file) {
      this.saveUser.avatar = res.data
      this.$forceUpdate()
    },
    // 上传头像前校验
    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2
      if (!isJPG) {
        this.$message.error('上传头像图片只能是 JPG 或 PNG 格式!')
      }
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 2MB!')
      }
      return isJPG && isLt2M
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await userApi.save(this.saveUser)
          if (res.success) {
            this.$message({
              message: '保存成功',
              type: 'success'
            })
            this.dialogVisible = false
            this.search()
          }
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await userApi.update(this.saveUser)
          if (res.success) {
            this.$message({
              message: '修改成功',
              type: 'success'
            })
            this.dialogVisible = false
            this.search()
          }
        }
      })
    },
    handleDelete(row) {
      if (row.isAdmin === 1) {
        this.$message({
          message: '超级管理员不能删除',
          type: 'warning'
        })
      } else {
        this.$confirm('此操作将永久删除该用户, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          userApi.delete(row.id).then(res => {
            if (res.success) {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
              this.search()
            }
          })
        }).catch(() => {})
      }
    },
    handleDeleteBatch() {
      if (this.multipleSelection.length > 0) {
        this.$confirm('此操作将永久删除选中记录, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          userApi.delete(this.multipleSelection).then(res => {
            if (res.success) {
              this.$message({
                type: 'success',
                message: '已删除非超级管理员用户!'
              })
              this.search()
            }
          })
        }).catch(() => {})
      } else {
        this.$message({
          message: '请选择要删除的行',
          type: 'warning'
        })
      }
    }
  }
}
</script>

<style scoped>
.el-aside {
  background-color: #fff;
  border-right: 2px solid #e6e6e6;
  border-top: 2px solid #e6e6e6;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}
.avatar {
  width: 100px;
  height: 100px;
  display: block;
}
</style>
