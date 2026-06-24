<template>
  <div class="app-container">
    <el-form :inline="true" :model="makerModel" size="small" label-width="100px">
      <el-form-item label="厂商名称">
        <el-input v-model="makerModel.name" placeholder="厂商名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="onSubmit">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleCreate">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="deleteBatch">批量删除选中</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="tableData"
      row-key="id"
      style="width: 100%;margin-bottom: 20px;"
      border
      stripe
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="80">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="name" label="厂商名称" />
      <el-table-column prop="orderLetter" label="排序字母" />
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" type="primary" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">删除当前行</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      background
      layout="total,prev, pager, next,jumper"
      :current-page="start"
      :page-size="size"
      :total="total"
      @current-change="search"
    />

    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible">
      <el-form ref="form" :model="saveMaker" :rules="rules" label-width="100px">
        <el-form-item label="厂商名称" prop="name">
          <el-input v-model="saveMaker.name" />
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
import makerApi from '@/api/auto_maker'

export default {
  name: 'MakerList',
  data() {
    return {
      makerModel: {},
      tableData: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      dialogFormVisible: false,
      saveMaker: {},
      dialogStatus: '',
      titleMap: {
        create: '新增厂商',
        update: '修改厂商'
      },
      rules: {
        name: [
          { required: true, message: '请输入厂商名称', trigger: 'blur' }
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
      const res = await makerApi.search(this.start, this.size, this.makerModel)
      this.tableData = res.data.records
      this.total = res.data.total
    },
    onSubmit() {
      this.search(1)
    },
    resetForm() {
      this.makerModel = {}
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    handleCreate() {
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.saveMaker = {}
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.saveMaker = row
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleDelete(row) {
      if (this.multipleSelection.length > 1 && this.multipleSelection.includes(row.id)) {
        this.$message({
          type: 'warning',
          message: '你已经勾选了多条数据，请点击上方【批量删除选中】'
        })
        return
      }
      this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        makerApi.delete(row.id).then(res => {
          if (res.success) {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.search()
          }
        })
      }).catch(() => {
      })
    },
    deleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message({
          type: 'warning',
          message: '请选择要删除的数据!'
        })
        return
      }
      this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        makerApi.delete(this.multipleSelection).then(res => {
          if (res.success) {
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
            this.search()
          }
        })
      }).catch(() => {
      })
    },
    createData() {
      this.$refs['form'].validate(valid => {
        if (!valid) {
          return false
        }
        makerApi.save(this.saveMaker).then(res => {
          if (res.success) {
            this.$message({
              type: 'success',
              message: '新增成功!'
            })
            this.dialogFormVisible = false
            this.search()
          }
        })
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (!valid) {
          return false
        }
        const res = await makerApi.update(this.saveMaker)
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
