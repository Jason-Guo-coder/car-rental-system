<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :inline="true" :model="violationModel" size="small">
      <el-form-item>
        <el-input v-model="violationModel.autoNum" placeholder="车牌号" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="violationModel.reason" placeholder="违章事由" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="violationModel.location" placeholder="违章地点" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="violationModel.lowFine" :min="0" placeholder="罚款下限" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="violationModel.highFine" :min="0" placeholder="罚款上限" />
      </el-form-item>
      <el-form-item>
        <el-date-picker
          v-model="violationTimeVal"
          type="datetimerange"
          value-format="yyyy-MM-dd HH:mm:ss"
          :picker-options="pickerOptions"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          align="right"
        />
      </el-form-item>
      <el-form-item>
        <el-select v-model="violationModel.status" placeholder="处理状态" clearable>
          <el-option v-for="item in statusList" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleCreate">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="deleteBatch">删除选中</el-button>
      </el-form-item>
    </el-form>
    <el-divider />

    <!-- 表格 -->
    <el-table :data="violationList" border stripe style="width: 100%; margin-bottom: 20px;" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="70">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="autoNum" label="车牌号" width="100" />
      <el-table-column prop="violationTime" label="违章时间" width="170" />
      <el-table-column prop="reason" label="违章事由" />
      <el-table-column prop="location" label="违章地点" />
      <el-table-column prop="deductPoints" label="扣分点数" width="100" />
      <el-table-column prop="fine" label="罚款金额" width="100" />
      <el-table-column prop="status" label="处理状态" width="100">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status == 0" type="danger">未处理</el-tag>
          <el-tag v-else type="success">已处理</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180">
        <template slot-scope="scope">
          <el-button type="primary" size="mini" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button type="danger" size="mini" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <!-- 新增/修改弹窗 -->
    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible" width="50%">
      <el-form ref="form" :model="saveViolation" :rules="rules" label-width="80px" size="small">
        <el-form-item label="车牌号码" prop="autoNum">
          <el-input v-model="saveViolation.autoNum" placeholder="请输入车牌号" @blur="checkAutoNum" />
        </el-form-item>
        <el-form-item label="违章时间" prop="violationTime">
          <el-date-picker v-model="saveViolation.violationTime" type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm:ss" />
        </el-form-item>
        <el-form-item label="违章事由" prop="reason">
          <el-input v-model="saveViolation.reason" placeholder="请输入违章事由" />
        </el-form-item>
        <el-form-item label="违章地点" prop="location">
          <el-input v-model="saveViolation.location" placeholder="请输入违章地点" />
        </el-form-item>
        <el-form-item label="扣分点数" prop="deductPoints">
          <el-input-number v-model="saveViolation.deductPoints" :min="0" placeholder="请输入扣分点数" />
        </el-form-item>
        <el-form-item label="罚款金额" prop="fine">
          <el-input-number v-model="saveViolation.fine" :min="0" placeholder="请输入罚款金额" />
        </el-form-item>
        <el-form-item label="处理状态">
          <el-radio-group v-model="saveViolation.status">
            <el-radio-button :label="0">未处理</el-radio-button>
            <el-radio-button :label="1">已处理</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" :disabled="isDisabled" @click="dialogStatus === 'create' ? createData() : updateData()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import violationApi from '@/api/violation'
import autoInfoApi from '@/api/auto_info'

export default {
  name: 'ViolationList',
  data() {
    return {
      isDisabled: false,
      violationModel: {},
      violationTimeVal: [],
      statusList: [
        { value: 0, label: '未处理' },
        { value: 1, label: '已处理' }
      ],
      violationList: [],
      multipleSelection: [],
      titleMap: {
        create: '新增违章',
        update: '修改违章'
      },
      dialogStatus: 'create',
      dialogFormVisible: false,
      saveViolation: {},
      start: 1,
      size: 5,
      total: 0,
      rules: {
        autoNum: [{ required: true, message: '请输入车牌号', trigger: 'blur' }],
        violationTime: [{ required: true, message: '请选择违章时间', trigger: 'change' }],
        location: [{ required: true, message: '请输入违章地点', trigger: 'blur' }],
        reason: [{ required: true, message: '请输入违章事由', trigger: 'blur' }]
      },
      pickerOptions: {
        shortcuts: [{
          text: '最近一周',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近一个月',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
            picker.$emit('pick', [start, end])
          }
        }, {
          text: '最近三个月',
          onClick(picker) {
            const end = new Date()
            const start = new Date()
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
            picker.$emit('pick', [start, end])
          }
        }]
      }
    }
  },
  created() {
    this.search()
  },
  methods: {
    async search(start = 1) {
      this.start = start
      const res = await violationApi.search(this.start, this.size, this.violationModel)
      if (res.success) {
        this.violationList = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      if (this.violationTimeVal && this.violationTimeVal.length === 2) {
        this.violationModel.lowViolationTime = this.violationTimeVal[0]
        this.violationModel.highViolationTime = this.violationTimeVal[1]
      } else {
        this.violationModel.lowViolationTime = undefined
        this.violationModel.highViolationTime = undefined
      }
      this.search(1)
    },
    resetForm() {
      this.violationModel = {}
      this.violationTimeVal = []
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    handleCreate() {
      this.saveViolation = { status: 0 }
      this.isDisabled = false
      this.dialogFormVisible = true
      this.dialogStatus = 'create'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.saveViolation = { ...row }
      this.isDisabled = false
      this.dialogFormVisible = true
      this.dialogStatus = 'update'
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    // 车牌号失焦校验是否存在
    checkAutoNum() {
      if (!this.saveViolation.autoNum) {
        return
      }
      autoInfoApi.exist(this.saveViolation).then(res => {
        if (res.success) {
          if (res.message === 'none') {
            this.$message({ message: '车牌号不存在', type: 'error' })
            this.isDisabled = true
          } else {
            this.isDisabled = false
          }
        }
      })
    },
    createData() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          violationApi.save(this.saveViolation).then(res => {
            if (res.success) {
              this.$message({ message: '保存成功', type: 'success' })
              this.dialogFormVisible = false
              this.search()
            }
          })
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          violationApi.update(this.saveViolation).then(res => {
            if (res.success) {
              this.$message({ message: '修改成功', type: 'success' })
              this.dialogFormVisible = false
              this.search()
            }
          })
        }
      })
    },
    handleDelete(row) {
      this.$confirm('此操作将永久删除该信息, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        violationApi.delete(row.id).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    },
    deleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message({ message: '请选择一条记录', type: 'warning' })
        return
      }
      this.$confirm('确认删除选中记录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        violationApi.delete(this.multipleSelection).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    }
  }
}
</script>

<style scoped></style>
