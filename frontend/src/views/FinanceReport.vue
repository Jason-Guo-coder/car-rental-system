<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
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

const toolboxIcons = {
  line: 'path://M4 17.5 L8.5 12.5 L12.5 15 L19 7.5',
  bar: 'path://M5 18 L8 18 L8 11 L5 11 Z M11 18 L14 18 L14 6 L11 6 Z M17 18 L20 18 L20 9 L17 9 Z',
  restore: 'path://M6.5 8.2 A7 7 0 1 1 5.5 15.5 M6.5 8.2 L6.5 4.8 L3.2 8.2 Z',
  save: 'path://M11 4 L13 4 L13 12 L16 9 L17.5 10.5 L12 16 L6.5 10.5 L8 9 L11 12 Z M5 18 L19 18 L19 20 L5 20 Z',
}

const toolboxIconStyle = {
  color: 'rgba(91, 110, 242, 0.08)',
  borderColor: '#5b6ef2',
  borderWidth: 1.8,
}

function readCost(data: Record<string, unknown> | null) {
  payable.value = Number(data?.countRentPayable ?? 0)
  actual.value = Number(data?.countRentActual ?? 0)
  deposit.value = Number(data?.countDeposit ?? 0)
}

function updateChart(chart: echarts.ECharts | null, name: string, data: ChartPair, color: string) {
  if (!chart) return
  const glow = `${color}30`
  const soft = `${color}16`
  const fade = `${color}03`
  chart.setOption({
    color: [color],
    grid: { left: 42, right: 18, top: 52, bottom: 34 },
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.88)',
      borderWidth: 0,
      borderRadius: 14,
      padding: [10, 12],
      textStyle: { color: '#1f2330', fontSize: 12 },
      extraCssText: 'box-shadow: 0 14px 34px rgba(60,70,130,.14); backdrop-filter: blur(18px);',
      axisPointer: {
        type: 'line',
        lineStyle: { color: glow, width: 2, type: 'solid' },
      },
      valueFormatter: (value: number) => `${value} 单`,
    },
    legend: {
      data: [name],
      top: 7,
      left: 8,
      icon: 'roundRect',
      itemWidth: 18,
      itemHeight: 8,
      textStyle: { color: '#5a5e6b', fontSize: 12, fontWeight: 500 },
    },
    toolbox: {
      right: 12,
      top: 2,
      itemSize: 17,
      itemGap: 14,
      iconStyle: toolboxIconStyle,
      emphasis: {
        iconStyle: {
          color: 'rgba(59, 131, 245, 0.16)',
          borderColor: '#3b83f5',
          borderWidth: 2.2,
        },
      },
      feature: {
        magicType: { type: ['line', 'bar'], icon: { line: toolboxIcons.line, bar: toolboxIcons.bar }, title: { line: '切换为折线图', bar: '切换为柱状图' } },
        restore: { icon: toolboxIcons.restore, title: '还原' },
        saveAsImage: { icon: toolboxIcons.save, title: '保存图片' },
      },
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: data[0],
      axisLine: { lineStyle: { color: 'rgba(140, 143, 156, 0.2)' } },
      axisTick: { show: false },
      axisLabel: { color: '#8c8f9c', margin: 14, fontSize: 11 },
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: 'rgba(91, 110, 242, 0.08)', type: 'dashed' } },
      axisLabel: { color: '#8c8f9c', fontSize: 11 },
    },
    series: [
      {
        name,
        type: 'line',
        smooth: true,
        symbol: 'emptyCircle',
        symbolSize: 8,
        showSymbol: data[1].length <= 12,
        data: data[1],
        barWidth: 18,
        showBackground: true,
        backgroundStyle: { color: 'rgba(91, 110, 242, 0.05)', borderRadius: [10, 10, 4, 4] },
        lineStyle: {
          width: 3.2,
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color },
            { offset: 1, color: '#7368f2' },
          ]),
          shadowBlur: 12,
          shadowColor: glow,
        },
        itemStyle: {
          color,
          borderColor: '#fff',
          borderWidth: 2.5,
          borderRadius: [10, 10, 4, 4],
        },
        emphasis: {
          focus: 'series',
          scale: true,
          itemStyle: {
            shadowBlur: 16,
            shadowColor: glow,
          },
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: soft },
            { offset: 0.58, color: `${color}08` },
            { offset: 1, color: fade },
          ]),
        },
      },
    ],
  })
}

function restoreChart(chart: echarts.ECharts | null, name: string, data: ChartPair, color: string) {
  setTimeout(() => updateChart(chart, name, data, color))
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
  rentalChart.on('restore', () => restoreChart(rentalChart, '出租数量', rentalData.value, '#5b8def'))
  returnChart.on('restore', () => restoreChart(returnChart, '归还数量', returnData.value, '#22b07d'))
  await loadReport()
  window.addEventListener('resize', resizeCharts)
})

watch(() => props.mode, loadReport)

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  rentalChart?.dispose()
  returnChart?.dispose()
})
</script>

<template>
  <div class="space-y-6">
    <PageHeader :title="title" :subtitle="subtitle">
      <template #actions>
        <div class="inline-flex rounded-full bg-white/60 p-1 shadow-glass-sm backdrop-blur">
          <router-link to="/finance" class="rounded-full px-3.5 py-2 text-xs font-medium text-ink-soft transition hover:bg-white/70 hover:text-brand">财务首页</router-link>
          <router-link
            to="/finance/dayReport"
            class="rounded-full px-3.5 py-2 text-xs font-medium transition"
            :class="isDay ? 'bg-brand-gradient text-white shadow-glass-sm' : 'text-ink-soft hover:bg-white/70 hover:text-brand'"
          >
            财务日报
          </router-link>
          <router-link
            to="/finance/monthReport"
            class="rounded-full px-3.5 py-2 text-xs font-medium transition"
            :class="!isDay ? 'bg-brand-gradient text-white shadow-glass-sm' : 'text-ink-soft hover:bg-white/70 hover:text-brand'"
          >
            财务月报
          </router-link>
        </div>
      </template>
    </PageHeader>

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
