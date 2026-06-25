<template>
  <div class="app-container">
    <el-form :inline="true" :model="rentalTypeModel" size="small" style="margin: 15px;">
      <el-form-item label="出租类型">
        <el-input v-model="rentalTypeModel.typeName" placeholder="请输入出租类型" />
      </el-form-item>
      <el-form-item label="最低折扣">
        <el-input-number v-model="rentalTypeModel.lowDiscount" :min="0" :max="1" :step="0.01" />
      </el-form-item>
      <el-form-item label="最高折扣">
        <el-input-number v-model="rentalTypeModel.highDiscount" :min="0" :max="1" :step="0.01" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleAdd">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="handleDeleteBatch">删除选中</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="tableData"
      border
      stripe
      style="width: 100%; margin-bottom: 15px;"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="80">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column label="类型名称" prop="typeName" />
      <el-table-column label="类型折扣" prop="typeDiscount" />
      <el-table-column label="备注" prop="remark" />
      <el-table-column label="操作" width="180">
        <template slot-scope="scope">
          <el-button size="mini" type="primary" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible">
      <el-form ref="form" :model="saveRentalTypeModel" :rules="rules" label-width="100px" style="margin: 15px;">
        <el-form-item label="类型名称" prop="typeName">
          <el-input v-model="saveRentalTypeModel.typeName" placeholder="请输入类型名称" />
        </el-form-item>
        <el-form-item label="类型折扣" prop="typeDiscount">
          <el-input-number v-model="saveRentalTypeModel.typeDiscount" :min="0" :max="1" :step="0.01" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="saveRentalTypeModel.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import rentalTypeApi from '@/api/rental_type'

export default {
  name: 'RentalTypeList',
  data() {
    return {
      rentalTypeModel: {
        lowDiscount: 0,
        highDiscount: 1
      },
      start: 1,
      size: 5,
      total: 0,
      tableData: [],
      multipleSelection: [],
      titleMap: {
        create: '新增',
        update: '修改'
      },
      dialogStatus: 'create',
      dialogFormVisible: false,
      saveRentalTypeModel: {},
      rules: {
        typeName: [
          { required: true, message: '请输入类型名称', trigger: 'blur' }
        ],
        typeDiscount: [
          { required: true, message: '请输入类型折扣', trigger: 'blur' }
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
      const res = await rentalTypeApi.search(this.start, this.size, this.rentalTypeModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      this.search(1)
    },
    resetForm() {
      this.tableData = []
      this.rentalTypeModel = {
        lowDiscount: 0,
        highDiscount: 1
      }
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
      this.dialogFormVisible = true
      this.saveRentalTypeModel = { typeDiscount: 1 }
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.saveRentalTypeModel = { ...row }
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleDelete(row) {
      this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        rentalTypeApi.delete(row.id).then(res => {
          if (res.success) {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.search()
          }
        })
      }).catch(() => {})
    },
    handleDeleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message({
          type: 'warning',
          message: '请选择要删除的数据!'
        })
        return
      }
      this.$confirm('此操作将永久删除选中数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        rentalTypeApi.delete(this.multipleSelection).then(res => {
          if (res.success) {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.search()
          }
        })
      }).catch(() => {})
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await rentalTypeApi.save(this.saveRentalTypeModel)
          if (res.success) {
            this.$message({
              type: 'success',
              message: '新增成功!'
            })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await rentalTypeApi.update(this.saveRentalTypeModel)
          if (res.success) {
            this.$message({
              type: 'success',
              message: '修改成功!'
            })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    }
  }
}
</script>

<style scoped></style>
