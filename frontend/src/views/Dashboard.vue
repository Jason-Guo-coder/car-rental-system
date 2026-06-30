<script setup lang="ts">
import { ref, onMounted, computed, onBeforeUnmount, watch } from 'vue'
import * as echarts from 'echarts'
import GlassCard from '@/components/GlassCard.vue'
import { useDashboardStore } from '@/stores/dashboard'
import { useAuthStore } from '@/stores/auth'

const store = useDashboardStore()
const auth = useAuthStore()

// 顶部问候语：按当前时段动态生成
const now = new Date()
const greeting = computed(() => {
  const h = now.getHours()
  if (h < 6) return '凌晨好'
  if (h < 12) return '上午好'
  if (h < 14) return '中午好'
  if (h < 18) return '下午好'
  return '晚上好'
})
const dateText = computed(() => {
  const w = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][now.getDay()]
  return `${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日 星期${w.slice(1)} · 今日运营一切正常`
})
const isEditorHome = computed(() => !auth.isAdmin)
const editorMenuItems = computed(() => auth.menuGroups.flatMap((group) => group.items))
const weeklyRevenueTotal = computed(() => store.weeklyRevenue.reduce((sum, item) => sum + item.value, 0))

// 统计卡图标色调映射
const statTone: Record<string, string> = {
  blue: 'from-[#3B83F5] to-[#6aa1f8]',
  green: 'from-[#22b07d] to-[#34c98e]',
  orange: 'from-[#f5a623] to-[#f97316]',
  red: 'from-[#f24d5c] to-[#fb7185]',
}
const trendTone: Record<string, string> = {
  up: 'bg-statusOk/10 text-statusOk',
  flat: 'bg-brand/10 text-brand',
  warn: 'bg-danger/10 text-danger',
}

const barRef = ref<HTMLElement>()
const pieRef = ref<HTMLElement>()
let barChart: echarts.ECharts | null = null
let pieChart: echarts.ECharts | null = null

function resize() {
  barChart?.resize()
  pieChart?.resize()
}

function updateRevenueChart() {
  if (!barChart) return
  barChart.setOption({
    xAxis: { data: store.weeklyRevenue.map((d) => d.day) },
    series: [{ data: store.weeklyRevenue.map((d) => d.value) }],
  })
}

function updateFleetChart() {
  if (!pieChart) return
  pieChart.setOption({
    series: [{ data: store.fleetStatus.map((f) => ({ value: f.value, name: f.name, itemStyle: { color: f.color } })) }],
  })
}

onMounted(() => {
  if (isEditorHome.value) return
  // 营收趋势柱状图（近 7 日，单位千元）
  barChart = echarts.init(barRef.value!)
  barChart.setOption({
    grid: { left: 36, right: 16, top: 20, bottom: 30 },
    tooltip: { trigger: 'axis', valueFormatter: (v: number) => `¥${v}k` },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: store.weeklyRevenue.map((d) => d.day),
      axisLine: { lineStyle: { color: '#e3e6f0' } },
      axisTick: { show: false },
      axisLabel: { color: '#8c8f9c' },
    },
    yAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: 'rgba(0,0,0,0.05)' } },
      axisLabel: { color: '#8c8f9c', formatter: '{value}' },
    },
    series: [
      {
        data: store.weeklyRevenue.map((d) => d.value),
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 8,
        lineStyle: { width: 3, color: '#5b6ef2' },
        itemStyle: { color: '#5b6ef2', borderColor: '#fff', borderWidth: 2 },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(91,110,242,0.28)' },
            { offset: 1, color: 'rgba(91,110,242,0.01)' },
          ]),
        },
      },
    ],
  })

  // 车队状态环图（中心显示总车辆）
  pieChart = echarts.init(pieRef.value!)
  pieChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} 辆' },
    series: [
      {
        type: 'pie',
        radius: ['62%', '82%'],
        center: ['50%', '50%'],
        avoidLabelOverlap: false,
        label: { show: false },
        padAngle: 4,
        itemStyle: { borderRadius: 10 },
        emphasis: { scale: true, scaleSize: 4 },
        data: store.fleetStatus.map((f) => ({ value: f.value, name: f.name, itemStyle: { color: f.color } })),
      },
    ],
  })

  window.addEventListener('resize', resize)
})

watch(() => store.weeklyRevenue, updateRevenueChart, { deep: true })
watch(() => store.fleetStatus, updateFleetChart, { deep: true })

onBeforeUnmount(() => {
  window.removeEventListener('resize', resize)
  barChart?.dispose()
  pieChart?.dispose()
})

// 待办圆点色
const todoDot: Record<string, string> = {
  danger: 'bg-danger',
  warning: 'bg-statusWarn',
  primary: 'bg-brand',
  purple: 'bg-rolepurple',
  success: 'bg-statusOk',
}
const todoTag: Record<string, string> = {
  danger: 'bg-danger/10 text-danger',
  warning: 'bg-statusWarn/10 text-statusWarn',
  primary: 'bg-brand/10 text-brand',
  purple: 'bg-rolepurple/10 text-rolepurple',
  success: 'bg-statusOk/10 text-statusOk',
}
</script>

<template>
  <div v-if="isEditorHome" class="space-y-6">
    <!-- 顶栏：问候语 + 日期 -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-semibold text-ink">{{ greeting }}，{{ auth.displayName }} <span class="ml-1">👋</span></h1>
        <p class="mt-1 text-sm text-ink-muted">业务人员首页</p>
      </div>
    </div>

    <GlassCard padding="p-6">
      <div class="flex items-center gap-5">
        <div class="flex h-20 w-20 items-center justify-center overflow-hidden rounded-3xl bg-brand-gradient text-2xl font-semibold text-white shadow-glass-sm">
          <img v-if="auth.avatar" :src="auth.avatar" :alt="auth.displayName" class="h-full w-full object-cover" />
          <span v-else>{{ auth.displayName.charAt(0).toUpperCase() }}</span>
        </div>
        <div>
          <p class="text-2xl font-semibold text-ink">{{ auth.displayName }}</p>
          <p class="mt-2 text-sm text-ink-muted">当前账号：{{ auth.username }}</p>
          <div class="mt-4 flex flex-wrap gap-2">
            <span v-for="code in auth.permissionCodes" :key="code" class="rounded-full bg-brand/10 px-3 py-1 text-xs font-medium text-brand">{{ code }}</span>
          </div>
        </div>
      </div>
    </GlassCard>

    <GlassCard padding="p-6">
      <p class="text-base font-semibold text-ink">可访问功能</p>
      <div class="mt-4 grid grid-cols-4 gap-3">
        <router-link
          v-for="item in editorMenuItems"
          :key="item.path"
          :to="item.path"
          class="flex items-center gap-2 rounded-2xl bg-white/60 px-4 py-3 text-sm font-medium text-ink-soft shadow-field transition hover:bg-white/90 hover:text-brand"
        >
          <el-icon><component :is="item.icon" /></el-icon>
          {{ item.title }}
        </router-link>
      </div>
    </GlassCard>
  </div>

  <div v-else class="space-y-6">
    <!-- 顶栏：问候语 + 日期 -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-semibold text-ink">{{ greeting }}，{{ auth.displayName }} <span class="ml-1">👋</span></h1>
        <p class="mt-1 text-sm text-ink-muted">{{ dateText }}</p>
      </div>
    </div>

    <!-- 4 张统计卡 -->
    <div class="grid grid-cols-4 gap-5">
      <GlassCard v-for="s in store.stats" :key="s.key" padding="p-5">
        <div class="flex items-start justify-between">
          <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-gradient-to-br text-white shadow-glass-sm" :class="statTone[s.tone]">
            <el-icon :size="22"><component :is="s.icon" /></el-icon>
          </div>
          <span class="rounded-full px-2.5 py-1 text-xs font-medium" :class="trendTone[s.trendTone]">{{ s.trend }}</span>
        </div>
        <p class="mt-4 text-sm text-ink-muted">{{ s.label }}</p>
        <p class="mt-1 text-3xl font-semibold text-ink">
          {{ s.valueMain }}<span class="text-base font-normal text-ink-muted">{{ s.valueLight }}</span>
        </p>
      </GlassCard>
    </div>

    <!-- 营收趋势 + 车队状态 -->
    <div class="grid grid-cols-3 gap-5">
      <GlassCard class="col-span-2">
        <div class="mb-2 flex items-center justify-between">
          <div>
            <p class="text-base font-semibold text-ink">营收趋势</p>
            <p class="mt-0.5 text-xs text-ink-muted">近 7 日 · 单位千元</p>
          </div>
          <p class="text-2xl font-semibold text-brand">¥{{ weeklyRevenueTotal.toFixed(1) }}k</p>
        </div>
        <div ref="barRef" class="h-[280px] w-full" />
      </GlassCard>

      <GlassCard>
        <div class="flex h-full flex-col">
          <p class="text-base font-semibold text-ink">车队状态</p>
          <div class="relative mt-2">
            <div ref="pieRef" class="h-[230px] w-full" />
            <!-- 环图中心总数 -->
            <div class="pointer-events-none absolute inset-0 flex flex-col items-center justify-center">
              <p class="text-3xl font-semibold text-ink">{{ store.fleetTotal }}</p>
              <p class="text-xs text-ink-muted">总车辆</p>
            </div>
          </div>
          <!-- 图例：下移填充底部留白 -->
          <div class="mt-auto grid grid-cols-2 gap-x-6 gap-y-3 pt-4">
            <div v-for="f in store.fleetStatus" :key="f.name" class="flex items-center gap-2 text-sm">
              <span class="h-2.5 w-2.5 rounded-full" :style="{ background: f.color }" />
              <span class="text-ink-soft">{{ f.name }}</span>
              <span class="ml-auto font-medium text-ink">{{ f.value }} 辆</span>
            </div>
          </div>
        </div>
      </GlassCard>
    </div>

    <!-- 底部双栏：进行中租约 + 待办提醒 -->
    <div class="grid grid-cols-2 items-stretch gap-5">
      <!-- 进行中的租约 -->
      <GlassCard class="flex h-full flex-col">
        <div class="mb-4 flex items-center justify-between">
          <p class="text-base font-semibold text-ink">进行中的租约</p>
          <router-link to="/order" class="text-sm text-brand hover:underline">查看全部</router-link>
        </div>
        <div class="grid flex-1 grid-cols-2 auto-rows-fr gap-3">
          <div v-for="lease in store.activeLeases" :key="lease.plate" class="flex h-full flex-col justify-between rounded-2xl bg-white/55 p-3 shadow-field">
            <div class="mb-2 flex items-center gap-3">
              <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-[#eef2ff] to-[#f5f0fb] text-ink-soft">
                <el-icon :size="20"><Van /></el-icon>
              </div>
              <div class="min-w-0 flex-1">
                <p class="truncate font-medium text-ink">{{ lease.plate }}</p>
                <p class="truncate text-xs text-ink-muted">{{ lease.model }}</p>
              </div>
            </div>
            <div class="space-y-1 text-xs">
              <div class="flex items-center justify-between gap-3">
                <span class="text-ink-muted">客户</span>
                <span class="truncate text-ink-soft">{{ lease.customer }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-ink-muted">租期</span>
                <span class="text-ink-soft">{{ lease.start }} ~ {{ lease.end }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-ink-muted">车辆</span>
                <span class="truncate text-ink-soft">{{ lease.carInfo }}</span>
              </div>
              <div class="flex items-center justify-between gap-3">
                <span class="text-ink-muted">里程</span>
                <span class="font-medium text-brand">{{ lease.mileage }}</span>
              </div>
            </div>
          </div>
          <el-empty v-if="!store.activeLeases.length" description="暂无进行中的租约" class="col-span-2" />
        </div>
      </GlassCard>

      <!-- 待办提醒 -->
      <GlassCard class="flex h-full flex-col">
        <p class="mb-4 text-base font-semibold text-ink">待办提醒</p>
        <div class="grid flex-1 auto-rows-fr gap-2">
          <router-link v-for="(t, i) in store.todos" :key="i" :to="t.route || '/dashboard'" class="flex h-full items-center gap-3 rounded-field px-3 py-2.5 transition-all hover:bg-white/60">
            <span class="h-2.5 w-2.5 shrink-0 rounded-full" :class="todoDot[t.tone]" />
            <div class="min-w-0 flex-1">
              <p class="text-sm font-medium text-ink">{{ t.title }}</p>
              <p class="truncate text-xs text-ink-muted">{{ t.desc }}</p>
            </div>
            <span class="shrink-0 rounded-full px-2.5 py-1 text-xs font-medium" :class="todoTag[t.tone]">{{ t.tag }}</span>
            <span class="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-white/70 text-ink-muted shadow-field transition hover:text-brand">
              <el-icon><ArrowRight /></el-icon>
            </span>
          </router-link>
          <el-empty v-if="!store.todos.length" description="暂无待办提醒" />
        </div>
      </GlassCard>
    </div>
  </div>
</template>
