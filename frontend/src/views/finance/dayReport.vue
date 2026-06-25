<template>
  <div class="app-container">
    <el-card style="margin-bottom: 15px;">
      <div class="cost-bar">
        当日应收金额：<el-tag type="success">{{ countRentPayable }}</el-tag>
        当日实收金额：<el-tag type="warning">{{ countRentActual }}</el-tag>
        当日收到押金：<el-tag type="danger">{{ countDeposit }}</el-tag>
      </div>
    </el-card>
    <el-card style="margin-bottom: 15px;">
      <div ref="rentalchart" :style="{ width: '100%', height: '400px' }" />
    </el-card>
    <el-card>
      <div ref="returnchart" :style="{ width: '100%', height: '400px' }" />
    </el-card>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import financeApi from '@/api/finance'

export default {
  name: 'FinanceDayReport',
  data() {
    return {
      rentalchart: null,
      returnchart: null,
      hoursRental: [],
      hoursReturn: [],
      rentalNum: [],
      returnNum: [],
      countRentPayable: 0,
      countRentActual: 0,
      countDeposit: 0
    }
  },
  created() {
    this.getCost()
  },
  mounted() {
    this.initRentalchart()
    this.initReturnchart()
    this.getData()
  },
  beforeDestroy() {
    if (this.rentalchart) {
      this.rentalchart.dispose()
    }
    if (this.returnchart) {
      this.returnchart.dispose()
    }
  },
  methods: {
    getCost() {
      financeApi.countDayCost().then(res => {
        if (res.success && res.data) {
          this.countRentPayable = res.data.countRentPayable || 0
          this.countRentActual = res.data.countRentActual || 0
          this.countDeposit = res.data.countDeposit || 0
        }
      })
    },
    getData() {
      financeApi.countDayRental().then(res => {
        if (res.success) {
          this.hoursRental = res.data[0]
          this.rentalNum = res.data[1]
          this.updateRentalChart()
        }
      })
      financeApi.countDayReturn().then(res => {
        if (res.success) {
          this.hoursReturn = res.data[0]
          this.returnNum = res.data[1]
          this.updateReturnChart()
        }
      })
    },
    updateRentalChart() {
      this.rentalchart.setOption({
        xAxis: { data: this.hoursRental },
        series: [{ data: this.rentalNum }]
      })
    },
    updateReturnChart() {
      this.returnchart.setOption({
        xAxis: { data: this.hoursReturn },
        series: [{ data: this.returnNum }]
      })
    },
    initRentalchart() {
      this.rentalchart = echarts.init(this.$refs.rentalchart)
      this.rentalchart.setOption({
        title: { text: '日报出租数据统计', subtext: new Date().toLocaleDateString() },
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' }},
        legend: { data: ['出租数量'] },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        toolbox: {
          show: true,
          feature: {
            magicType: { type: ['line', 'bar'], show: true },
            restore: { show: true },
            saveAsImage: { show: true }
          }
        },
        xAxis: { type: 'category', boundaryGap: false, data: this.hoursRental },
        yAxis: { type: 'value' },
        series: [{ name: '出租数量', type: 'line', data: this.rentalNum }]
      })
    },
    initReturnchart() {
      this.returnchart = echarts.init(this.$refs.returnchart)
      this.returnchart.setOption({
        title: { text: '日报归还数据统计', subtext: new Date().toLocaleDateString() },
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' }},
        legend: { data: ['归还数量'] },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        toolbox: {
          show: true,
          feature: {
            magicType: { type: ['line', 'bar'], show: true },
            restore: { show: true },
            saveAsImage: { show: true }
          }
        },
        xAxis: { type: 'category', boundaryGap: false, data: this.hoursReturn },
        yAxis: { type: 'value' },
        series: [{ name: '归还数量', type: 'line', data: this.returnNum }]
      })
    }
  }
}
</script>

<style scoped>
.cost-bar {
  font-size: 15px;
  line-height: 30px;
}
.cost-bar .el-tag {
  margin-right: 20px;
}
</style>
