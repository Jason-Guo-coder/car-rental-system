<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :model="maintainModel" label-width="80px" :inline="true" size="small">
      <el-form-item>
        <el-input v-model="maintainModel.autoNum" placeholder="车牌号码" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="maintainModel.item" placeholder="保养项目" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="maintainModel.location" placeholder="保养地点" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="maintainModel.lowCost" :min="0" placeholder="金额下限" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="maintainModel.highCost" :min="0" placeholder="金额上限" />
      </el-form-item>
      <el-form-item>
        <el-date-picker
          v-model="maintainTimeVal"
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
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleCreate">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="deleteBatch">删除选中</el-button>
      </el-form-item>
    </el-form>
    <el-divider />

    <!-- 表格 -->
    <el-table :data="tableData" border stripe style="width: 100%; margin-bottom: 20px;" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="70">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="autoNum" label="车牌号码" width="120" />
      <el-table-column prop="maintainTime" label="保养时间" width="180" />
      <el-table-column prop="item" label="保养项目" />
      <el-table-column prop="location" label="保养地点" />
      <el-table-column prop="cost" label="保养费用" width="100" />
      <el-table-column label="操作" width="180">
        <template slot-scope="scope">
          <el-button type="primary" size="mini" icon="el-icon-edit" @click="handleUpdate(scope.row)">编辑</el-button>
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
      <el-form ref="form" :model="saveMaintain" :rules="rules" label-width="80px" size="small">
        <el-form-item label="车牌号码" prop="autoNum">
          <el-select v-model="saveMaintain.autoNum" placeholder="请选择" style="width: 100%;">
            <el-option v-for="item in autoList" :key="item.id" :label="item.autoNum" :value="item.autoNum">
              <span style="float: left;">{{ item.autoNum }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px;">未保次数：{{ item.expectedNum - item.actualNum }}</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="保养时间" prop="maintainTime">
          <el-date-picker v-model="saveMaintain.maintainTime" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" />
        </el-form-item>
        <el-form-item label="保养项目" prop="item">
          <el-input v-model="saveMaintain.item" placeholder="请输入保养项目" />
        </el-form-item>
        <el-form-item label="保养地点" prop="location">
          <el-input v-model="saveMaintain.location" placeholder="请输入保养地点" />
        </el-form-item>
        <el-form-item label="保养费用" prop="cost">
          <el-input-number v-model="saveMaintain.cost" :min="0" placeholder="请输入保养费用" />
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
import maintainApi from '@/api/maintain'
import autoInfoApi from '@/api/auto_info'

export default {
  name: 'MaintainList',
  data() {
    return {
      maintainModel: {},
      maintainTimeVal: [],
      tableData: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      titleMap: {
        create: '新增保养',
        update: '修改保养'
      },
      dialogStatus: 'create',
      dialogFormVisible: false,
      saveMaintain: {},
      autoList: [],
      rules: {
        autoNum: [{ required: true, message: '请选择车牌号码', trigger: 'change' }],
        maintainTime: [{ required: true, message: '请选择保养日期', trigger: 'change' }],
        location: [{ required: true, message: '请输入保养地点', trigger: 'blur' }],
        item: [{ required: true, message: '请输入保养项目', trigger: 'blur' }],
        cost: [{ required: true, message: '请输入保养费用', trigger: 'blur' }]
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
      const res = await maintainApi.search(this.start, this.size, this.maintainModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    async getAutoList() {
      const res = await autoInfoApi.toBeMaintain()
      if (res.success) {
        this.autoList = res.data
      }
    },
    handleSearch() {
      if (this.maintainTimeVal && this.maintainTimeVal.length === 2) {
        this.maintainModel.lowMaintainTime = this.maintainTimeVal[0]
        this.maintainModel.highMaintainTime = this.maintainTimeVal[1]
      } else {
        this.maintainModel.lowMaintainTime = undefined
        this.maintainModel.highMaintainTime = undefined
      }
      this.search(1)
    },
    resetForm() {
      this.maintainModel = {}
      this.maintainTimeVal = []
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(item => {
        this.multipleSelection.push(item.id)
      })
    },
    handleCreate() {
      this.getAutoList()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.saveMaintain = {}
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.getAutoList()
      this.saveMaintain = { ...row }
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleDelete(row) {
      this.$confirm('此操作将永久删除该信息, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        maintainApi.delete(row.id).then(res => {
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
        maintainApi.delete(this.multipleSelection).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    },
    createData() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          maintainApi.save(this.saveMaintain).then(res => {
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
          maintainApi.update(this.saveMaintain).then(res => {
            if (res.success) {
              this.$message({ message: '修改成功', type: 'success' })
              this.dialogFormVisible = false
              this.search()
            }
          })
        }
      })
    }
  }
}
</script>

<style scoped></style>
