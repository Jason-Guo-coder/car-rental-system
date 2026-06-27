<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import * as echarts from 'echarts'
import PageHeader from '@/components/PageHeader.vue'
import GlassCard from '@/components/GlassCard.vue'
import StatCard from '@/components/StatCard.vue'
import { api } from '@/api/backend'

const props = defineProps<{
  mode: 'day' | 'month'
}>()

type ChartPair = [Array<string | number>, number[]]

const isDay = computed(() => props.mode === 'day')
const title = computed(() => isDay.value ? '财务日报' : '财务月报')
const subtitle = computed(() => isDay.value ? '当日收款、出租与归还统计' : '当月收款、出租与归还统计')
const prefix = computed(() => isDay.value ? '当日' : '当月')
const dateText = computed(() => new Date().toLocaleDateString())

const payable = ref(0)
const actual = ref(0)
const deposit = ref(0)
const rentalData = ref<ChartPair>([[], []])
const returnData = ref<ChartPair>([[], []])
const rentalRef = ref<HTMLElement>()
const returnRef = ref<HTMLElement>()
let rentalChart: echarts.ECharts | null = null
let returnChart: echarts.ECharts | null = null

function readCost(data: Record<string, unknown> | null) {
  payable.value = Number(data?.countRentPayable ?? 0)
  actual.value = Number(data?.countRentActual ?? 0)
  deposit.value = Number(data?.countDeposit ?? 0)
}

function updateChart(chart: echarts.ECharts | null, name: string, data: ChartPair, color: string) {
  if (!chart) return
  chart.setOption({
    grid: { left: 44, right: 18, top: 48, bottom: 32 },
    tooltip: { trigger: 'axis' },
    legend: { data: [name], top: 8, textStyle: { color: '#5a5e6b' } },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: data[0],
      axisLine: { lineStyle: { color: '#c9cdd9' } },
      axisTick: { show: false },
      axisLabel: { color: '#8c8f9c' },
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      splitLine: { lineStyle: { color: 'rgba(0,0,0,0.05)' } },
      axisLabel: { color: '#8c8f9c' },
    },
    series: [
      {
        name,
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 7,
        data: data[1],
        lineStyle: { width: 3, color },
        itemStyle: { color, borderColor: '#fff', borderWidth: 2 },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: `${color}44` },
            { offset: 1, color: `${color}05` },
          ]),
        },
      },
    ],
  })
}

async function loadReport() {
  const costRequest = isDay.value ? api.finance.dayCost() : api.finance.monthCost()
  const rentalRequest = isDay.value ? api.finance.dayRental() : api.finance.monthRental()
  const returnRequest = isDay.value ? api.finance.dayReturn() : api.finance.monthReturn()

  const [cost, rental, returned] = await Promise.all([
    costRequest.catch(() => null),
    rentalRequest.catch(() => [[], []] as ChartPair),
    returnRequest.catch(() => [[], []] as ChartPair),
  ])

  readCost(cost)
  rentalData.value = rental
  returnData.value = returned
  updateChart(rentalChart, '出租数量', rentalData.value, '#5b8def')
  updateChart(returnChart, '归还数量', returnData.value, '#22b07d')
}

function resizeCharts() {
  rentalChart?.resize()
  returnChart?.resize()
}

onMounted(async () => {
  rentalChart = echarts.init(rentalRef.value!)
  returnChart = echarts.init(returnRef.value!)
  await loadReport()
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  rentalChart?.dispose()
  returnChart?.dispose()
})
</script>

<template>
  <div class="space-y-6">
    <PageHeader :title="title" :subtitle="subtitle" />

    <div class="grid grid-cols-3 gap-5">
      <StatCard :label="`${prefix}应收金额`" :value="payable.toLocaleString()" suffix="元" icon="Money" tone="brand" />
      <StatCard :label="`${prefix}实收金额`" :value="actual.toLocaleString()" suffix="元" icon="Wallet" tone="green" />
      <StatCard :label="`${prefix}收到押金`" :value="deposit.toLocaleString()" suffix="元" icon="Tickets" tone="orange" />
    </div>

    <GlassCard padding="p-5">
      <div class="mb-3">
        <p class="text-base font-semibold text-ink">{{ isDay ? '日报出租数据统计' : '月报出租数据统计' }}</p>
        <p class="mt-0.5 text-xs text-ink-muted">{{ dateText }}</p>
      </div>
      <div ref="rentalRef" class="h-[360px] w-full" />
    </GlassCard>

    <GlassCard padding="p-5">
      <div class="mb-3">
        <p class="text-base font-semibold text-ink">{{ isDay ? '日报归还数据统计' : '月报归还数据统计' }}</p>
        <p class="mt-0.5 text-xs text-ink-muted">{{ dateText }}</p>
      </div>
      <div ref="returnRef" class="h-[360px] w-full" />
    </GlassCard>
  </div>
</template>
