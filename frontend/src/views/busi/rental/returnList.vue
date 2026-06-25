<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :model="orderModel" :inline="true" label-width="80px" size="small">
      <el-form-item label="订单编号">
        <el-input v-model="orderModel.orderNum" placeholder="请输入订单号" />
      </el-form-item>
      <el-form-item label="车牌号码">
        <el-input v-model="orderModel.autoNum" placeholder="请输入车牌号码" />
      </el-form-item>
      <el-form-item label="客户姓名">
        <el-input v-model="orderModel.customerName" placeholder="请输入客户姓名" />
      </el-form-item>
      <el-form-item label="客户电话">
        <el-input v-model="orderModel.customerTel" placeholder="请输入客户电话" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
      </el-form-item>
    </el-form>
    <el-divider />

    <!-- 未归还订单表格 -->
    <el-table :data="tableData" border stripe style="margin-bottom: 20px;">
      <el-table-column label="序号" width="50">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="orderNum" label="订单编号" width="190" />
      <el-table-column prop="autoNum" label="车牌号码" width="110" />
      <el-table-column prop="customerName" label="客户姓名" width="100" />
      <el-table-column prop="customerTel" label="客户电话" width="130" />
      <el-table-column prop="rentalTime" label="出租时间" width="170" />
      <el-table-column prop="typeName" label="出租类型" width="100" />
      <el-table-column prop="typeDiscount" label="享受折扣" width="90" />
      <el-table-column prop="rent" label="日租金额" width="90" />
      <el-table-column prop="deposit" label="车辆押金" width="90" />
      <el-table-column prop="mileage" label="起租里程" width="90" />
      <el-table-column label="操作" width="100" fixed="right">
        <template slot-scope="scope">
          <el-button icon="el-icon-finished" size="mini" type="success" @click="handleReturn(scope.row)">归还</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      background
      layout="total, prev, pager, next, jumper"
      :current-page="start"
      :page-size="size"
      :total="total"
      @current-change="search"
    />

    <!-- 归还弹窗 -->
    <el-dialog title="车辆归还" :visible.sync="dialogVisible" width="50%">
      <el-form ref="form" :model="saveOrder" :rules="rules" label-width="100px" :inline="true">
        <el-form-item label="订单编号">
          <el-input v-model="saveOrder.orderNum" readonly />
        </el-form-item>
        <el-form-item label="车牌号码">
          <el-input v-model="saveOrder.autoNum" readonly />
        </el-form-item>
        <el-form-item label="客户姓名">
          <el-input v-model="saveOrder.customerName" readonly />
        </el-form-item>
        <el-form-item label="客户电话">
          <el-input v-model="saveOrder.customerTel" readonly />
        </el-form-item>
        <el-form-item label="起租里程">
          <el-input v-model="saveOrder.mileage" readonly />
        </el-form-item>
        <el-form-item label="出租时间">
          <el-input v-model="saveOrder.rentalTime" readonly />
        </el-form-item>
        <el-form-item label="出租类型">
          <el-input v-model="saveOrder.typeName" readonly />
        </el-form-item>
        <el-form-item label="享受折扣">
          <el-input v-model="saveOrder.typeDiscount" readonly />
        </el-form-item>
        <el-form-item label="日租金额">
          <el-input v-model="saveOrder.rent" readonly />
        </el-form-item>
        <el-form-item label="车辆押金">
          <el-input v-model="saveOrder.deposit" readonly />
        </el-form-item>
        <el-form-item label="归还里程" prop="returnMileage">
          <el-input v-model="saveOrder.returnMileage" @change="handleCheck" />
        </el-form-item>
        <el-form-item label="归还时间" prop="returnTime">
          <el-date-picker
            v-model="saveOrder.returnTime"
            type="datetime"
            placeholder="请选择归还时间"
            value-format="yyyy-MM-dd HH:mm:ss"
            @change="handleChange"
          />
        </el-form-item>
        <el-form-item label="应付金额">
          <el-input v-model="saveOrder.rentPayable" readonly />
        </el-form-item>
        <el-form-item label="实付金额">
          <el-input v-model="saveOrder.rentActual" readonly />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button :disabled="isDisabled" type="primary" @click="doReturn">归 还</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import orderApi from '@/api/order'

export default {
  name: 'ReturnList',
  data() {
    return {
      orderModel: {},
      start: 1,
      size: 5,
      total: 0,
      tableData: [],
      saveOrder: {},
      dialogVisible: false,
      isDisabled: false,
      rules: {
        returnMileage: [{ required: true, message: '请输入还车里程', trigger: 'blur' }],
        returnTime: [{ required: true, message: '请选择还车时间', trigger: 'change' }]
      }
    }
  },
  created() {
    this.search()
  },
  methods: {
    async search(start = 1) {
      this.start = start
      const res = await orderApi.searchUnfinished(this.start, this.size, this.orderModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    handleSearch() {
      this.search(1)
    },
    resetForm() {
      this.orderModel = {}
      this.search(1)
    },
    handleReturn(row) {
      this.saveOrder = { ...row }
      this.isDisabled = false
      this.dialogVisible = true
      // 默认归还时间为当前时间
      this.saveOrder.returnTime = this.getDateTime()
      this.countRent()
      this.$nextTick(() => {
        this.$refs['form'].clearValidate()
      })
    },
    // 还车里程必须大于起租里程
    handleCheck() {
      if (this.saveOrder.returnMileage <= this.saveOrder.mileage) {
        this.$message({ message: '还车里程必须大于起租里程', type: 'error' })
        this.isDisabled = true
      } else {
        this.isDisabled = false
      }
    },
    handleChange() {
      this.countRent()
    },
    // 计算应付/实付租金：天数(向上取整) * 日租, 实付 = 应付 * 折扣
    countRent() {
      if (!this.saveOrder.rentalTime || !this.saveOrder.returnTime) {
        return
      }
      const rentalTime = new Date(this.saveOrder.rentalTime)
      const returnTime = new Date(this.saveOrder.returnTime)
      const timeDiff = Math.abs(returnTime.getTime() - rentalTime.getTime())
      const days = Math.ceil(timeDiff / (1000 * 60 * 60 * 24))
      const c1 = days * this.saveOrder.rent
      const c2 = parseInt(c1 * this.saveOrder.typeDiscount)
      this.$set(this.saveOrder, 'rentPayable', c1)
      this.$set(this.saveOrder, 'rentActual', c2)
    },
    getDateTime() {
      const d = new Date()
      const year = d.getFullYear()
      const month = this.k2(d.getMonth() + 1)
      const day = this.k2(d.getDate())
      const hour = this.k2(d.getHours())
      const minute = this.k2(d.getMinutes())
      const second = this.k2(d.getSeconds())
      return `${year}-${month}-${day} ${hour}:${minute}:${second}`
    },
    k2(v) {
      return v >= 10 ? v : '0' + v
    },
    doReturn() {
      this.$refs['form'].validate(valid => {
        if (valid) {
          orderApi.update(this.saveOrder).then(res => {
            if (res.success) {
              this.$message({ message: '车辆归还成功，请在订单详情中查看', type: 'success' })
              this.dialogVisible = false
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
