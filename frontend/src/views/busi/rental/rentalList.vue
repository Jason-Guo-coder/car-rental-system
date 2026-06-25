<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :inline="true" :model="infoModel" size="mini">
      <el-form-item>
        <el-select v-model="infoModel.makerId" placeholder="请选择厂商" clearable style="width: 130px;" @change="handleMakerChange">
          <el-option v-for="item in makerList" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-select v-model="infoModel.brandId" placeholder="请选择品牌" clearable style="width: 130px;">
          <el-option v-for="item in brandList" :key="item.id" :label="item.brandName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-input v-model="infoModel.autoNum" placeholder="请输入车牌号码" style="width: 130px;" />
      </el-form-item>
      <el-form-item>
        <el-select v-model="infoModel.infoType" placeholder="请选择类型" clearable style="width: 130px;">
          <el-option label="燃油车" :value="0" />
          <el-option label="电动车" :value="1" />
          <el-option label="混动车" :value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="infoModel.lowRent" :min="0" placeholder="租金下限" style="width: 150px;" />
      </el-form-item>
      <el-form-item>
        <el-input-number v-model="infoModel.highRent" :min="0" placeholder="租金上限" style="width: 150px;" />
      </el-form-item>
      <el-form-item>
        <el-date-picker
          v-model="infoModel.registrationDateVal"
          type="daterange"
          align="right"
          unlink-panels
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          :picker-options="pickerOptions"
          value-format="yyyy-MM-dd"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
        <el-button type="warning" icon="el-icon-refresh" @click="resetForm">重置</el-button>
      </el-form-item>
    </el-form>
    <el-divider />

    <!-- 未租车辆表格 -->
    <el-table :data="tableData" border stripe style="margin-bottom: 20px;">
      <el-table-column label="序号" width="60">
        <template slot-scope="scope">{{ (start - 1) * size + scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column prop="autoNum" label="车牌" width="110" />
      <el-table-column prop="makerName" label="厂商" width="110" />
      <el-table-column prop="brandName" label="品牌" width="110" />
      <el-table-column prop="infoType" label="类型" width="90">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.infoType == 0">燃油车</el-tag>
          <el-tag v-else-if="scope.row.infoType == 1" type="success">电动车</el-tag>
          <el-tag v-else-if="scope.row.infoType == 2" type="warning">混动车</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="color" label="颜色" width="80">
        <template slot-scope="scope">
          <span :style="{ background: scope.row.color, height: '20px', width: '50px', display: 'inline-block', border: '1px solid #ddd' }" />
        </template>
      </el-table-column>
      <el-table-column label="排量" width="90">
        <template slot-scope="scope">{{ scope.row.displacement + scope.row.unit }}</template>
      </el-table-column>
      <el-table-column prop="mileage" label="里程" width="90" />
      <el-table-column prop="rent" label="租金" width="80" />
      <el-table-column prop="deposit" label="押金" width="80" />
      <el-table-column prop="registrationDate" label="上牌日期" width="110" />
      <el-table-column label="图片" width="90">
        <template slot-scope="scope">
          <el-image v-if="scope.row.pic" :src="scope.row.pic" :preview-src-list="[scope.row.pic]" fit="cover" style="width: 60px; height: 45px;" />
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" fixed="right">
        <template slot-scope="scope">
          <el-button type="primary" size="mini" icon="el-icon-bangzhu" @click="handleRent(scope.row)">出租</el-button>
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

    <!-- 出租第一步：车辆信息弹窗 -->
    <el-dialog title="车辆信息" :visible.sync="dialogFormVisible" width="35%">
      <el-form ref="infoForm" :model="saveInfo" :rules="rules" label-width="100px">
        <el-form-item label="所属厂商">
          <el-input v-model="saveInfo.makerName" readonly />
        </el-form-item>
        <el-form-item label="所属品牌">
          <el-input v-model="saveInfo.brandName" readonly />
        </el-form-item>
        <el-form-item label="车牌号码">
          <el-input v-model="saveInfo.autoNum" readonly />
        </el-form-item>
        <el-form-item label="车辆类型">
          <el-input v-if="saveInfo.infoType == 0" value="燃油车" readonly />
          <el-input v-else-if="saveInfo.infoType == 1" value="电动车" readonly />
          <el-input v-else-if="saveInfo.infoType == 2" value="混动车" readonly />
        </el-form-item>
        <el-form-item label="车辆颜色">
          <span :style="{ background: saveInfo.color, height: '20px', width: '100px', display: 'inline-block', border: '1px solid #ddd' }" />
        </el-form-item>
        <el-form-item label="汽车排量">
          <el-input v-model="saveInfo.displacement" readonly />
        </el-form-item>
        <el-form-item label="排量单位">
          <el-input v-model="saveInfo.unit" readonly />
        </el-form-item>
        <el-form-item label="上牌日期">
          <el-input v-model="saveInfo.registrationDate" readonly />
        </el-form-item>
        <el-form-item label="出租类型" prop="typeId">
          <el-select v-model="saveInfo.typeId" placeholder="请选择">
            <el-option v-for="item in rentalTypeList" :key="item.id" :label="item.typeName" :value="item.id">
              <span style="float: left;">{{ item.typeName }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px;">折扣：{{ item.typeDiscount * 100 }}%</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="行驶里程" prop="mileage">
          <el-input-number v-model="saveInfo.mileage" :min="0" placeholder="请输入行驶里程" />
        </el-form-item>
        <el-form-item label="日租金额" prop="rent">
          <el-input-number v-model="saveInfo.rent" :min="0" placeholder="请输入日租金额" />
        </el-form-item>
        <el-form-item label="车辆押金" prop="deposit">
          <el-input-number v-model="saveInfo.deposit" :min="0" placeholder="请输入车辆押金" />
        </el-form-item>
        <el-form-item label="车辆图片">
          <el-image style="width: 100px; height: 100px;" :src="saveInfo.pic" :preview-src-list="srcList" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="doNext">下一步</el-button>
      </div>
    </el-dialog>

    <!-- 出租第二步：客户信息弹窗 -->
    <el-dialog title="客户信息" :visible.sync="dialogCustomerVisible" width="40%">
      <el-form ref="customerForm" :model="saveCustomer" :rules="rules" label-width="80px">
        <el-form-item label="联系电话" prop="tel">
          <el-input v-model="saveCustomer.tel" type="tel" @change="selectCustomerByTel" />
        </el-form-item>
        <el-form-item label="身份证号" prop="idNum">
          <el-input v-model="saveCustomer.idNum" @change="setCustomerInfo" />
        </el-form-item>
        <el-form-item label="客户姓名" prop="name">
          <el-input v-model="saveCustomer.name" />
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
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogCustomerVisible = false">取 消</el-button>
        <el-button type="primary" @click="createOrder">提交订单</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import makerApi from '@/api/auto_maker'
import brandApi from '@/api/auto_brand'
import autoInfoApi from '@/api/auto_info'
import rentalTypeApi from '@/api/rental_type'
import customerApi from '@/api/customer'
import orderApi from '@/api/order'

export default {
  name: 'RentalList',
  data() {
    return {
      infoModel: {
        status: 0,
        makerId: undefined,
        brandId: undefined,
        autoNum: undefined,
        infoType: undefined,
        lowRent: undefined,
        highRent: undefined,
        registrationDateVal: undefined
      },
      makerList: [],
      brandList: [],
      tableData: [],
      start: 1,
      size: 5,
      total: 0,
      dialogFormVisible: false,
      dialogCustomerVisible: false,
      saveInfo: {},
      rentalTypeList: [],
      srcList: [],
      saveOrder: {},
      saveCustomer: {},
      isSaveCustomer: false, // 是否已存在的老客户
      rules: {
        typeId: [{ required: true, message: '请选择出租类型', trigger: 'change' }],
        name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
        tel: [
          { required: true, message: '请输入电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
        ],
        idNum: [
          { required: true, message: '请输入身份证', trigger: 'blur' },
          { min: 18, max: 18, message: '请输入18位身份证号', trigger: 'blur' }
        ]
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
    this.searchMakerList()
    this.selectRentalType()
  },
  methods: {
    // 查询所有未租车辆（status=0）
    async search(start = 1) {
      this.start = start
      const res = await autoInfoApi.search(this.start, this.size, this.infoModel)
      if (res.success) {
        this.tableData = res.data.records
        this.total = res.data.total
      }
    },
    searchMakerList() {
      makerApi.selectAll().then(res => {
        if (res.success) {
          this.makerList = res.data
        }
      })
    },
    selectRentalType() {
      rentalTypeApi.selectAll().then(res => {
        if (res.success) {
          this.rentalTypeList = res.data
        }
      })
    },
    handleSearch() {
      if (this.infoModel.registrationDateVal !== undefined && this.infoModel.registrationDateVal !== null) {
        this.infoModel.lowRegistrationDate = this.infoModel.registrationDateVal[0]
        this.infoModel.highRegistrationDate = this.infoModel.registrationDateVal[1]
      }
      this.search(1)
    },
    resetForm() {
      this.infoModel = {
        status: 0,
        makerId: undefined,
        brandId: undefined,
        autoNum: undefined,
        infoType: undefined,
        lowRent: undefined,
        highRent: undefined,
        registrationDateVal: undefined
      }
      this.brandList = []
      this.search(1)
    },
    handleMakerChange(val) {
      this.infoModel.brandId = undefined
      this.brandList = []
      if (val) {
        brandApi.selectByMakerId(val).then(res => {
          if (res.success) {
            this.brandList = res.data
          }
        })
      }
    },
    // 点击出租，弹出车辆信息
    handleRent(row) {
      this.saveInfo = { ...row }
      this.srcList = row.pic ? [row.pic] : []
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['infoForm'].clearValidate()
      })
    },
    // 下一步：校验车辆表单，带出订单基础信息，进入客户弹窗
    doNext() {
      this.$refs['infoForm'].validate(valid => {
        if (valid) {
          this.saveOrder.autoId = this.saveInfo.id
          this.saveOrder.rent = this.saveInfo.rent
          this.saveOrder.deposit = this.saveInfo.deposit
          this.saveOrder.mileage = this.saveInfo.mileage
          this.saveOrder.typeId = this.saveInfo.typeId
          this.dialogFormVisible = false
          this.dialogCustomerVisible = true
          this.saveCustomer = {}
          this.isSaveCustomer = false
          this.$nextTick(() => {
            this.$refs['customerForm'].clearValidate()
          })
        }
      })
    },
    // 录入电话后查老客户回填
    selectCustomerByTel() {
      customerApi.selectCustomerByTel(this.saveCustomer).then(res => {
        if (res.data != null) {
          this.saveCustomer = res.data
          this.isSaveCustomer = true
        } else {
          const tel = this.saveCustomer.tel
          this.saveCustomer = { tel: tel }
          this.isSaveCustomer = false
        }
      })
    },
    // 身份证号推算性别、年龄、出生日期
    setCustomerInfo(val) {
      if (!val || val.length !== 18) {
        return
      }
      const sex = val.charAt(val.length - 2)
      this.saveCustomer.gender = sex % 2
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
    // 调后台保存订单
    addOrder() {
      orderApi.save(this.saveOrder).then(res => {
        if (res.success) {
          this.$message({ message: '创建订单成功，请在订单管理中查看', type: 'success' })
          this.saveOrder = {}
          this.saveCustomer = {}
          this.dialogCustomerVisible = false
          this.search()
        }
      })
    },
    // 提交订单：新客户先存再下单，老客户直接下单
    createOrder() {
      this.$refs['customerForm'].validate(valid => {
        if (valid) {
          if (!this.isSaveCustomer) {
            customerApi.save(this.saveCustomer).then(res => {
              if (res.success) {
                this.saveOrder.customerId = res.data
                this.addOrder()
              }
            })
          } else {
            this.saveOrder.customerId = this.saveCustomer.id
            this.addOrder()
          }
        }
      })
    }
  }
}
</script>

<style scoped></style>
