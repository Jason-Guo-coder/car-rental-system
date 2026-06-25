<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :inline="true" :model="customerModel" size="small">
      <el-form-item>
        <el-input v-model="customerModel.name" placeholder="请输入客户姓名" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="customerModel.tel" placeholder="请输入联系电话" />
      </el-form-item>
      <el-form-item>
        <el-input v-model="customerModel.idNum" placeholder="请输入身份证号" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="customerModel.lowAge" :min="0" placeholder="年龄低值" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="customerModel.highAge" :min="0" placeholder="年龄高值" />
      </el-form-item>
      <el-form-item>
        <el-select v-model="customerModel.gender" placeholder="请选择客户性别" clearable>
          <el-option label="男" :value="1" />
          <el-option label="女" :value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
        <el-button type="success" icon="el-icon-plus" @click="handleCreate">新增</el-button>
        <el-button type="danger" icon="el-icon-delete" @click="deleteBatch">删除选中</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格 -->
    <el-table :data="tableData" border stripe style="width: 100%; margin-bottom: 20px;" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="序号" width="60">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column label="客户姓名" prop="name" />
      <el-table-column label="身份证号" prop="idNum" />
      <el-table-column label="客户年龄" prop="age" />
      <el-table-column label="联系电话" prop="tel" />
      <el-table-column label="客户性别" prop="gender">
        <template slot-scope="scope">{{ scope.row.gender == 1 ? '男' : '女' }}</template>
      </el-table-column>
      <el-table-column label="出生日期" prop="birthday" />
      <el-table-column label="客户状态" prop="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status == 1" type="success">白名单</el-tag>
          <el-tag v-else type="danger">黑名单</el-tag>
        </template>
      </el-table-column>
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
    <el-dialog :title="titleMap[dialogStatus]" :visible.sync="dialogFormVisible" width="40%">
      <el-form ref="form" :model="saveCustomer" :rules="rules" label-width="80px">
        <el-form-item label="客户姓名" prop="name">
          <el-input v-model="saveCustomer.name" />
        </el-form-item>
        <el-form-item label="身份证号" prop="idNum">
          <el-input v-model="saveCustomer.idNum" @change="setCustomerInfo" />
        </el-form-item>
        <el-form-item label="联系电话" prop="tel">
          <el-input v-model="saveCustomer.tel" type="tel" />
        </el-form-item>
        <el-form-item label="客户年龄" prop="age">
          <el-input v-model="saveCustomer.age" :readonly="true" />
        </el-form-item>
        <el-form-item label="客户性别" prop="gender">
          <el-radio-group v-model="saveCustomer.gender">
            <el-radio-button :label="1" disabled>男</el-radio-button>
            <el-radio-button :label="0" disabled>女</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="出生日期" prop="birthday">
          <el-date-picker v-model="saveCustomer.birthday" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" :readonly="true" />
        </el-form-item>
        <el-form-item label="客户状态" prop="status">
          <el-radio-group v-model="saveCustomer.status">
            <el-radio-button :label="true">白名单</el-radio-button>
            <el-radio-button :label="false">黑名单</el-radio-button>
          </el-radio-group>
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
import customerApi from '@/api/customer'

export default {
  name: 'CustomerList',
  data() {
    return {
      customerModel: {},
      tableData: [],
      multipleSelection: [],
      start: 1,
      size: 5,
      total: 0,
      dialogFormVisible: false,
      dialogStatus: 'create',
      saveCustomer: {},
      titleMap: {
        create: '新增客户',
        update: '修改客户'
      },
      rules: {
        name: [
          { required: true, message: '请输入客户姓名', trigger: 'blur' }
        ],
        idNum: [
          { required: true, message: '请输入身份证号', trigger: 'blur' },
          { min: 18, max: 18, message: '请输入18位身份证号', trigger: 'blur' }
        ],
        tel: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
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
      const res = await customerApi.search(this.start, this.size, this.customerModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      this.search(1)
    },
    resetForm() {
      this.customerModel = {}
      this.search(1)
    },
    handleSelectionChange(val) {
      this.multipleSelection = []
      val.forEach(element => {
        this.multipleSelection.push(element.id)
      })
    },
    handleCreate() {
      this.saveCustomer = { status: true }
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    handleUpdate(row) {
      this.saveCustomer = { ...row }
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    // 身份证号改变，自动推算性别、出生日期、年龄
    setCustomerInfo(val) {
      if (!val || val.length !== 18) {
        return
      }
      // 性别：倒数第二位，奇数为男(1)，偶数为女(0)
      const sex = val.charAt(val.length - 2)
      this.saveCustomer.gender = sex % 2
      // 出生日期：第7~14位 yyyyMMdd
      const birthday = val.substring(6, 14)
      const year = birthday.substring(0, 4)
      const month = birthday.substring(4, 6)
      const day = birthday.substring(6, 8)
      const birthDate = new Date(year, month - 1, day)
      const now = new Date()
      const timeDiff = Math.abs(now.getTime() - birthDate.getTime())
      if (timeDiff > 0) {
        this.saveCustomer.age = Math.floor(timeDiff / (1000 * 60 * 60 * 24 * 365))
        this.saveCustomer.birthday = `${year}-${month}-${day}`
      }
      this.$forceUpdate()
    },
    createData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await customerApi.save(this.saveCustomer)
          if (res.success) {
            this.$message({ message: '保存成功', type: 'success' })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    },
    updateData() {
      this.$refs['form'].validate(async valid => {
        if (valid) {
          const res = await customerApi.update(this.saveCustomer)
          if (res.success) {
            this.$message({ message: '修改成功', type: 'success' })
            this.dialogFormVisible = false
            this.search()
          }
        }
      })
    },
    handleDelete(row) {
      this.$confirm('此操作将永久删除该客户, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        customerApi.delete(row.id).then(res => {
          if (res.success) {
            this.$message({ type: 'success', message: '删除成功!' })
            this.search()
          }
        })
      }).catch(() => {})
    },
    deleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message({ type: 'warning', message: '请选择要删除的客户!' })
        return
      }
      this.$confirm('此操作将永久删除选中客户, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        customerApi.delete(this.multipleSelection).then(res => {
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
