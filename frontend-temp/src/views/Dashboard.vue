<script setup lang="ts">
import { ref, onMounted, computed, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import { Search } from '@element-plus/icons-vue'
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
const keyword = ref('')
const isEditorHome = computed(() => !auth.isAdmin)

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

onMounted(() => {
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
// 进度条颜色：进度越高越暖
function leaseBar(p: number) {
  if (p >= 60) return 'from-[#f5a623] to-[#f97316]'
  if (p >= 40) return 'from-[#5b8def] to-[#7368f2]'
  return 'from-[#22b07d] to-[#34c98e]'
}
</script>

<template>
  <div class="space-y-6">
    <!-- 顶栏：问候语 + 日期 + 搜索框 -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-semibold text-ink">{{ greeting }}，{{ auth.displayName }} <span class="ml-1">👋</span></h1>
        <p class="mt-1 text-sm text-ink-muted">{{ dateText }}</p>
      </div>
      <div class="glass-field flex h-11 w-72 items-center gap-2 px-4">
        <el-icon class="text-ink-muted"><Search /></el-icon>
        <input v-model="keyword" placeholder="搜索车牌 / 订单 / 客户" class="w-full border-0 bg-transparent text-sm outline-none placeholder:text-ink-muted" />
      </div>
    </div>

    <GlassCard v-if="isEditorHome" padding="p-5">
      <div class="flex items-center gap-4">
        <div class="flex h-14 w-14 items-center justify-center overflow-hidden rounded-2xl bg-brand-gradient text-lg font-semibold text-white shadow-glass-sm">
          <img v-if="auth.avatar" :src="auth.avatar" :alt="auth.displayName" class="h-full w-full object-cover" />
          <span v-else>{{ auth.displayName.charAt(0).toUpperCase() }}</span>
        </div>
        <div>
          <p class="text-base font-semibold text-ink">当前账号：{{ auth.username }}</p>
          <p class="mt-1 text-sm text-ink-muted">角色视图：业务人员 · 仅显示后端授权菜单与操作</p>
        </div>
      </div>
    </GlassCard>

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
          <p class="text-2xl font-semibold text-brand">¥128.6k</p>
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
    <div class="grid grid-cols-2 gap-5">
      <!-- 进行中的租约 -->
      <GlassCard>
        <div class="mb-4 flex items-center justify-between">
          <p class="text-base font-semibold text-ink">进行中的租约</p>
          <router-link to="/order" class="text-sm text-brand hover:underline">查看全部</router-link>
        </div>
        <div class="space-y-4">
          <div v-for="lease in store.activeLeases" :key="lease.plate" class="flex items-center gap-4">
            <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-[#eef2ff] to-[#f5f0fb] text-ink-soft">
              <el-icon :size="20"><Van /></el-icon>
            </div>
            <div class="min-w-0 flex-1">
              <div class="flex items-center justify-between">
                <p class="font-medium text-ink">{{ lease.plate }} · {{ lease.model }}</p>
                <span class="text-sm font-medium text-ink-soft">{{ lease.progress }}%</span>
              </div>
              <div class="mt-0.5 flex items-center justify-between">
                <p class="text-xs text-ink-muted">客户 {{ lease.customer }}</p>
                <p class="text-xs text-ink-muted">{{ lease.start }} ~ {{ lease.end }}</p>
              </div>
              <!-- 进度条 -->
              <div class="mt-2 h-1.5 w-full overflow-hidden rounded-full bg-black/5">
                <div class="h-full rounded-full bg-gradient-to-r" :class="leaseBar(lease.progress)" :style="{ width: lease.progress + '%' }" />
              </div>
            </div>
          </div>
        </div>
      </GlassCard>

      <!-- 待办提醒 -->
      <GlassCard>
        <p class="mb-4 text-base font-semibold text-ink">待办提醒</p>
        <div class="space-y-1">
          <div v-for="(t, i) in store.todos" :key="i" class="flex items-center gap-3 rounded-field px-2 py-2.5 transition-all hover:bg-white/60">
            <span class="h-2.5 w-2.5 shrink-0 rounded-full" :class="todoDot[t.tone]" />
            <div class="min-w-0 flex-1">
              <p class="text-sm font-medium text-ink">{{ t.title }}</p>
              <p class="truncate text-xs text-ink-muted">{{ t.desc }}</p>
            </div>
            <span class="shrink-0 rounded-full px-2.5 py-1 text-xs font-medium" :class="todoTag[t.tone]">{{ t.tag }}</span>
          </div>
        </div>
      </GlassCard>
    </div>
  </div>
</template>
