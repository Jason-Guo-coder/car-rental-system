<template>
  <div class="app-container">
    <el-form :inline="true" size="small">
      <el-form-item>
        <el-button type="success" icon="el-icon-plus" @click="handleAdd">新增</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="tableData"
      style="width: 100%"
      border
      stripe
      row-key="id"
      :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
    >
      <el-table-column prop="permissionLable" label="菜单名称" />
      <el-table-column prop="parentLabel" label="上级菜单" />
      <el-table-column prop="permissionType" label="菜单类型">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.permissionType === 0" type="warning">根目录</el-tag>
          <el-tag v-else-if="scope.row.permissionType === 1" type="success">菜单</el-tag>
          <el-tag v-else>按钮</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="routeName" label="路由名称" />
      <el-table-column prop="routePath" label="路由地址" />
      <el-table-column prop="routeUrl" label="组件路径" />
      <el-table-column prop="icon" label="菜单图标">
        <template slot-scope="scope">
          <i v-if="scope.row.icon && scope.row.icon.indexOf('el-icon') !== -1" :class="scope.row.icon" />
          <svg-icon v-else-if="scope.row.icon" :icon-class="scope.row.icon" />
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200px">
        <template slot-scope="scope">
          <el-button type="primary" size="mini" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible">
      <el-form ref="form" :model="savePermission" :rules="rules" label-width="80px">
        <el-form-item label="上级菜单" prop="parentLabel">
          <el-input v-model="savePermission.parentLabel" placeholder="请选择上级菜单" :readonly="true" @click.native="openPermissionSelect" />
        </el-form-item>
        <el-form-item label="菜单名称" prop="permissionLable">
          <el-input v-model="savePermission.permissionLable" autocomplete="off" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="菜单类型" prop="permissionType">
          <el-radio-group v-model="savePermission.permissionType">
            <el-radio v-for="item in typeList" :key="item.value" :label="item.value">{{ item.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="权限标识" prop="permissionCode">
          <el-input v-model="savePermission.permissionCode" placeholder="请输入权限标识" />
        </el-form-item>
        <el-form-item v-if="savePermission.permissionType !== 2" label="组件路径" prop="routeUrl">
          <el-input v-model="savePermission.routeUrl" placeholder="请输入组件路径" />
        </el-form-item>
        <el-form-item label="菜单图标" prop="icon">
          <el-select v-model="savePermission.icon" placeholder="请选择图标">
            <el-option v-for="item in icons" :key="item.value" :label="item.label" :value="item.value">
              <span style="float: left">{{ item.label }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">{{ item.value }}</span>
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="选择上级菜单" :visible.sync="dialogPermissionVisible" width="30%">
      <el-tree
        ref="tree"
        :data="treeData"
        :props="defaultProps"
        node-key="id"
        :default-expand-all="true"
        highlight-current
        empty-text="未获取菜单数据"
        @node-click="handleNodeClick"
      />
      <div slot="footer" class="dialog-footer">
        <el-button @click="closeTree">取 消</el-button>
        <el-button type="primary" @click="handleTreeConfirm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import permissionApi from '@/api/permission'

export default {
  name: 'PermissionList',
  data() {
    return {
      tableData: [],
      dialogFormVisible: false,
      dialogPermissionVisible: false,
      dialogStatus: 'create',
      titleMap: {
        create: '新增菜单',
        update: '修改菜单'
      },
      savePermission: {},
      selectedPermission: {},
      treeData: [],
      defaultProps: {
        children: 'children',
        label: 'permissionLable'
      },
      typeList: [
        { value: 0, label: '根目录' },
        { value: 1, label: '菜单' },
        { value: 2, label: '按钮' }
      ],
      icons: [
        { value: 'component', label: '根目录' },
        { value: 'guide', label: '菜单' },
        { value: 'el-icon-plus', label: '新增' },
        { value: 'el-icon-delete', label: '删除' },
        { value: 'el-icon-edit', label: '修改' },
        { value: 'el-icon-search', label: '查询' }
      ],
      rules: {
        parentLabel: [
          { required: true, message: '请选择上级菜单', trigger: 'change' }
        ],
        permissionLable: [
          { required: true, message: '请输入菜单名称', trigger: 'blur' }
        ],
        permissionType: [
          { required: true, message: '请选择菜单类型', trigger: 'change' }
        ],
        permissionCode: [
          { required: true, message: '请输入权限标识', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.search()
  },
  methods: {
    async search() {
      const res = await permissionApi.search()
      if (res.success) {
        this.tableData = res.data
      }
    },
    handleAdd() {
      this.dialogFormVisible = true
      this.savePermission = {}
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleEdit(row) {
      this.dialogFormVisible = true
      this.savePermission = { ...row }
      this.dialogStatus = 'update'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    async openPermissionSelect() {
      this.selectedPermission = {}
      const res = await permissionApi.tree()
      if (res.success) {
        this.treeData = res.data
      }
      this.dialogPermissionVisible = true
    },
    handleNodeClick(data) {
      this.selectedPermission = data
    },
    closeTree() {
      this.dialogPermissionVisible = false
      this.selectedPermission = {}
    },
    handleTreeConfirm() {
      if (!this.selectedPermission || this.selectedPermission.id === undefined) {
        this.$message.warning('请选择上级菜单')
        return
      }
      this.$set(this.savePermission, 'pid', this.selectedPermission.id)
      this.$set(this.savePermission, 'parentLabel', this.selectedPermission.permissionLable)
      this.dialogPermissionVisible = false
      this.$nextTick(() => {
        this.$refs['form'].validateField('parentLabel')
      })
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (!valid) {
          return false
        }
        const res = await permissionApi.save(this.savePermission)
        if (res.success) {
          this.$message({
            type: 'success',
            message: '新增成功!'
          })
          this.dialogFormVisible = false
          this.search()
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (!valid) {
          return false
        }
        const res = await permissionApi.update(this.savePermission)
        if (res.success) {
          this.$message({
            type: 'success',
            message: '更新成功!'
          })
          this.dialogFormVisible = false
          this.search()
        }
      })
    },
    handleDelete(row) {
      permissionApi.hasChildren(row.id).then(res => {
        if (res.message === '有') {
          this.$message({
            type: 'warning',
            message: '该菜单下有子菜单，不能删除!'
          })
        } else {
          this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(async() => {
            const res = await permissionApi.delete(row.id)
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
    }
  }
}
</script>
