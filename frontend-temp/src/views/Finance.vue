<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'
import * as echarts from 'echarts'
import PageHeader from '@/components/PageHeader.vue'
import StatCard from '@/components/StatCard.vue'
import GlassCard from '@/components/GlassCard.vue'
import { useOrderStore } from '@/stores/order'
import { useDashboardStore } from '@/stores/dashboard'

const orderStore = useOrderStore()
const dashboardStore = useDashboardStore()
const barRef = ref<HTMLElement>()
const typeRef = ref<HTMLElement>()
let barChart: echarts.ECharts | undefined
let pieChart: echarts.ECharts | undefined

const financeMonthly = computed(() => dashboardStore.financeMonthly)
const financeByType = computed(() => dashboardStore.financeByType)
const totalRevenue = computed(() => financeMonthly.value.reduce((s, m) => s + m.revenue, 0))
const totalCost = computed(() => financeMonthly.value.reduce((s, m) => s + m.cost, 0))
const profit = computed(() => totalRevenue.value - totalCost.value)

function updateBarChart() {
  if (!barChart) return
  barChart.setOption({
    grid: { left: 50, right: 20, top: 40, bottom: 30 },
    tooltip: { trigger: 'axis' },
    legend: { data: ['营业收入', '运营成本'], top: 0, textStyle: { color: '#5a5e6b' } },
    xAxis: { type: 'category', data: financeMonthly.value.map((m) => m.month), axisLine: { lineStyle: { color: '#c9cdd9' } }, axisLabel: { color: '#8c8f9c' } },
    yAxis: { type: 'value', splitLine: { lineStyle: { color: 'rgba(0,0,0,0.05)' } }, axisLabel: { color: '#8c8f9c' } },
    series: [
      { name: '营业收入', type: 'bar', data: financeMonthly.value.map((m) => m.revenue), itemStyle: { color: '#5b8def', borderRadius: [6, 6, 0, 0] }, barWidth: 16 },
      { name: '运营成本', type: 'bar', data: financeMonthly.value.map((m) => m.cost), itemStyle: { color: '#c4b5fd', borderRadius: [6, 6, 0, 0] }, barWidth: 16 },
    ],
  })
}

function updatePieChart() {
  if (!pieChart) return
  pieChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} 元 ({d}%)' },
    legend: { bottom: 0, icon: 'circle', textStyle: { color: '#5a5e6b' } },
    series: [
      {
        type: 'pie',
        radius: ['50%', '72%'],
        center: ['50%', '42%'],
        label: { show: false },
        data: financeByType.value,
      },
    ],
  })
}

function resizeCharts() {
  barChart?.resize()
  pieChart?.resize()
}

watch(financeMonthly, updateBarChart, { deep: true })
watch(financeByType, updatePieChart, { deep: true })

onMounted(() => {
  barChart = echarts.init(barRef.value!)
  pieChart = echarts.init(typeRef.value!)
  updateBarChart()
  updatePieChart()
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  barChart?.dispose()
  pieChart?.dispose()
})
</script>

<template>
  <div class="space-y-6">
    <PageHeader title="财务报表" subtitle="经营收支分析与财务数据汇总" />

    <div class="grid grid-cols-4 gap-5">
      <StatCard label="年度营收" :value="(totalRevenue / 10000).toFixed(1)" suffix="万元" icon="Money" tone="brand" />
      <StatCard label="年度成本" :value="(totalCost / 10000).toFixed(1)" suffix="万元" icon="ShoppingCart" tone="orange" />
      <StatCard label="年度净利" :value="(profit / 10000).toFixed(1)" suffix="万元" icon="TrendCharts" tone="green" />
      <StatCard label="在租订单" :value="orderStore.rentingCount" suffix="单" icon="Tickets" tone="purple" />
    </div>

    <div class="grid grid-cols-3 gap-5">
      <GlassCard class="col-span-2">
        <p class="mb-4 text-base font-semibold text-ink">月度收支对比</p>
        <div ref="barRef" class="h-[300px] w-full" />
      </GlassCard>
      <GlassCard>
        <p class="mb-4 text-base font-semibold text-ink">出租类型收入构成</p>
        <div ref="typeRef" class="h-[300px] w-full" />
      </GlassCard>
    </div>

    <GlassCard>
      <p class="mb-4 text-base font-semibold text-ink">年度月度财务明细</p>
      <el-table :data="financeMonthly" class="glass-table">
        <el-table-column prop="month" label="月份" width="100" />
        <el-table-column label="营业收入">
          <template #default="{ row }">¥{{ row.revenue.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="运营成本">
          <template #default="{ row }">¥{{ row.cost.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="净利润">
          <template #default="{ row }">
            <span class="font-medium text-statusOk">¥{{ (row.revenue - row.cost).toLocaleString() }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="orders" label="订单数" width="100">
          <template #default="{ row }">{{ row.orders }} 单</template>
        </el-table-column>
        <el-table-column label="利润率" width="120">
          <template #default="{ row }">{{ row.revenue ? (((row.revenue - row.cost) / row.revenue) * 100).toFixed(1) : '0.0' }}%</template>
        </el-table-column>
      </el-table>
    </GlassCard>
  </div>
</template>
