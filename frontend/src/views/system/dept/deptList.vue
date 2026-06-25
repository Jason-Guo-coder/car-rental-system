<template>
  <div class="app-container">
    <el-form :inline="true" :model="deptModel" size="small" label-width="80px">
      <el-form-item label="部门名称">
        <el-input v-model="deptModel.deptName" placeholder="请输入部门名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="onSubmit">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button v-if="hasPermission('sys:dept:add')" type="success" icon="el-icon-plus" @click="handleCreate">新增</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="tableData"
      border
      stripe
      style="width: 100%"
      row-key="id"
      :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
      default-expand-all
    >
      <el-table-column label="部门名称" prop="deptName" />
      <el-table-column prop="parentName" label="上级部门" />
      <el-table-column prop="phone" label="部门电话" />
      <el-table-column prop="address" label="部门地址" />
      <el-table-column label="操作" width="200px">
        <template slot-scope="scope">
          <el-button v-if="hasPermission('sys:dept:edit')" type="primary" size="mini" icon="el-icon-edit" @click="handleUpdate(scope.row)">编辑</el-button>
          <el-button v-if="hasPermission('sys:dept:delete')" type="danger" size="mini" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible">
      <el-form ref="form" :model="saveDept" :rules="rules" label-width="80px" size="small">
        <el-form-item label="上级部门" prop="parentName">
          <el-input v-model="saveDept.parentName" placeholder="请选择上级部门" :readonly="true" @click.native="openDeptSelect" />
        </el-form-item>
        <el-form-item label="部门名称" prop="deptName">
          <el-input v-model="saveDept.deptName" placeholder="请输入部门名称" />
        </el-form-item>
        <el-form-item label="部门电话" prop="phone">
          <el-input v-model="saveDept.phone" placeholder="请输入部门电话" />
        </el-form-item>
        <el-form-item label="部门地址" prop="address">
          <el-input v-model="saveDept.address" placeholder="请输入部门地址" />
        </el-form-item>
        <el-form-item label="部门排序" prop="orderNum">
          <el-input-number v-model="saveDept.orderNum" placeholder="请输入部门排序" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="选择上级部门" :visible.sync="dialogTreeVisible" width="30%">
      <el-tree
        :data="treeData"
        :props="defaultProps"
        default-expand-all
        empty-text="未获取部门数据"
        :highlight-current="true"
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
import deptApi from '@/api/dept'

export default {
  name: 'DeptList',
  data() {
    return {
      deptModel: {},
      tableData: [],
      dialogStatus: 'create',
      titleMap: {
        create: '新增部门',
        update: '修改部门'
      },
      dialogFormVisible: false,
      dialogTreeVisible: false,
      saveDept: {},
      treeData: [],
      selectedDept: {},
      defaultProps: {
        children: 'children',
        label: 'deptName'
      },
      rules: {
        parentName: [
          { required: true, message: '请选择上级部门', trigger: 'change' }
        ],
        deptName: [
          { required: true, message: '请输入部门名称', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.search()
  },
  methods: {
    async search() {
      const res = await deptApi.search(this.deptModel)
      if (res.success) {
        this.tableData = res.data
      }
    },
    onSubmit() {
      this.search()
    },
    resetForm() {
      this.deptModel = {}
      this.tableData = []
      this.search()
    },
    handleCreate() {
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.saveDept = {}
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.saveDept = row
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    async openDeptSelect() {
      this.selectedDept = {}
      const res = await deptApi.selectTree()
      if (res.success) {
        this.treeData = res.data
      }
      this.dialogTreeVisible = true
    },
    handleNodeClick(data) {
      this.selectedDept = data
    },
    closeTree() {
      this.dialogTreeVisible = false
      this.selectedDept = {}
    },
    handleTreeConfirm() {
      if (!this.selectedDept || this.selectedDept.id === undefined) {
        this.$message.warning('请选择上级部门')
        return
      }
      this.$set(this.saveDept, 'pid', this.selectedDept.id)
      this.$set(this.saveDept, 'parentName', this.selectedDept.deptName)
      this.dialogTreeVisible = false
      this.$nextTick(() => {
        this.$refs['form'].validateField('parentName')
      })
    },
    async handleDelete(row) {
      // 先做校验，判断当前部门下是否有子部门
      const hasChildrenRes = await deptApi.hasChildren(row.id)
      if (hasChildrenRes.message === '有') {
        this.$message({
          type: 'warning',
          message: '该部门下有子部门，不能删除!'
        })
      } else {
        this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async() => {
          const res = await deptApi.delete(row.id)
          if (res.success) {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.search()
          }
        }).catch(() => {})
      }
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (!valid) {
          return false
        }
        const res = await deptApi.save(this.saveDept)
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
        const res = await deptApi.update(this.saveDept)
        if (res.success) {
          this.$message({
            type: 'success',
            message: '修改成功!'
          })
          this.dialogFormVisible = false
          this.search()
        }
      })
    }
  }
}
</script>
