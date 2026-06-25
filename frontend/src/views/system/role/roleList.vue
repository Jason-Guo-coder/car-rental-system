<template>
  <div class="app-container">
    <el-form :model="roleModel" label-width="80px" :inline="true" style="margin: 15px;" size="small">
      <el-form-item label="角色名称">
        <el-input v-model="roleModel.roleName" placeholder="请输入角色名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="queryRoleList">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        <el-button v-if="hasPermission('sys:role:save')" type="success" icon="el-icon-plus" @click="addRole">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="deleteBatchRole">删除选中</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="roleList"
      border
      stripe
      style="width: 100%;margin-bottom: 15px;"
      row-key="id"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="80">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="roleName" label="角色名称" />
      <el-table-column prop="roleCode" label="角色编码" />
      <el-table-column prop="remark" label="角色描述" />
      <el-table-column label="操作" width="260">
        <template slot-scope="scope">
          <div class="role-actions">
            <el-button v-if="hasPermission('sys:role:edit')" type="primary" size="mini" icon="el-icon-edit" @click="editRole(scope.row)">编辑</el-button>
            <el-button v-if="hasPermission('sys:role:delete')" type="danger" size="mini" icon="el-icon-delete" @click="deleteRole(scope.row)">删除</el-button>
            <el-button type="success" size="mini" icon="el-icon-setting" @click="handlePermission(scope.row)">权限分配</el-button>
          </div>
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

    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogVisible">
      <el-form ref="form" :model="saveRole" :rules="rules" label-width="80px" style="margin: 15px;" size="small">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="saveRole.roleName" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="角色编码" prop="roleCode">
          <el-input v-model="saveRole.roleCode" placeholder="请输入角色编码" />
        </el-form-item>
        <el-form-item label="角色描述" prop="remark">
          <el-input v-model="saveRole.remark" :rows="3" type="textarea" placeholder="请输入角色描述" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog :title="title" :visible.sync="dialogPermissionVisible" width="40%">
      <el-tree
        ref="tree"
        :data="treeData"
        show-checkbox
        node-key="id"
        :default-checked-keys="checkedKeys"
        :props="defaultProps"
        default-expand-all
        empty-text="暂无数据"
        check-strictly
      />
      <div slot="footer" class="dialog-footer">
        <el-button @click="clearSelect">取 消</el-button>
        <el-button type="primary" @click="savePermission">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import roleApi from '@/api/role'

export default {
  name: 'RoleList',
  data() {
    return {
      roleModel: {},
      roleList: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      dialogVisible: false,
      dialogPermissionVisible: false,
      dialogStatus: 'create',
      saveRole: {},
      treeData: [],
      checkedKeys: [],
      title: '',
      roleId: null,
      defaultProps: {
        children: 'children',
        label: 'permissionLable'
      },
      titleMap: {
        create: '新增角色',
        update: '修改角色'
      },
      rules: {
        roleName: [
          { required: true, message: '请输入角色名称', trigger: 'blur' }
        ],
        roleCode: [
          { required: true, message: '请输入角色编码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.search()
  },
  methods: {
    async search(start = 1) {
      this.start = start
      this.roleModel.createrId = this.$store.getters.createrId
      const res = await roleApi.search(this.start, this.size, this.roleModel)
      if (res.success) {
        this.roleList = res.data.records
        this.total = res.data.total
      }
    },
    queryRoleList() {
      this.search(1)
    },
    resetQuery() {
      this.roleModel = {}
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    addRole() {
      this.dialogStatus = 'create'
      this.dialogVisible = true
      this.saveRole = {}
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    editRole(row) {
      this.dialogStatus = 'update'
      this.dialogVisible = true
      this.saveRole = { ...row }
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    deleteBatchRole() {
      if (this.multipleSelection.length === 0) {
        this.$message({
          message: '请选择要删除的角色',
          type: 'warning'
        })
      } else {
        this.$confirm('此操作将永久删除数据, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          roleApi.delete(this.multipleSelection).then(res => {
            if (res.success) {
              this.$message({
                type: 'success',
                message: '已成功删除没有绑定用户的角色!'
              })
              this.search()
            }
          })
        })
      }
    },
    deleteRole(row) {
      roleApi.hasUser(row.id).then(res => {
        if (res.message === '有') {
          this.$message({
            message: '该角色下有用户，不能删除',
            type: 'warning'
          })
        } else {
          this.$confirm('此操作将永久删除该角色, 是否继续?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(async() => {
            const res = await roleApi.delete(row.id)
            if (res.success) {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
              this.search()
            }
          }).catch(() => {})
        }
      })
    },
    handlePermission(row) {
      this.roleId = row.id
      this.title = `${row.roleName}权限分配`
      this.dialogPermissionVisible = true
      const params = { roleId: row.id, userId: this.$store.getters.createrId }
      roleApi.permissionTree(params).then(res => {
        if (res.success) {
          this.treeData = res.data.permissionList
          this.checkedKeys = res.data.checkedList
          this.$nextTick(() => {
            this.$refs.tree.setCheckedKeys(res.data.checkedList)
          })
        }
      })
    },
    clearSelect() {
      this.dialogPermissionVisible = false
      this.checkedKeys = []
    },
    savePermission() {
      const permissionIds = this.$refs.tree.getCheckedKeys()
      roleApi.assignPermission(this.roleId, permissionIds).then(res => {
        if (res.success) {
          this.$message({
            message: '权限分配成功',
            type: 'success'
          })
          this.dialogPermissionVisible = false
        }
      })
    },
    createData() {
      this.$refs.form.validate(async valid => {
        if (valid) {
          this.saveRole.createrId = this.$store.getters.createrId
          const res = await roleApi.save(this.saveRole)
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
      this.$refs.form.validate(async valid => {
        if (valid) {
          const res = await roleApi.update(this.saveRole)
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
    }
  }
}
</script>

<style scoped>
.role-actions {
  white-space: nowrap;
}
</style>
