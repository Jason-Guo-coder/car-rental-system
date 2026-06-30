/** 首页仪表盘加载后端数据前的默认展示数据 */

/** 顶部统计卡 */
export interface DashStat {
  key: string
  label: string
  /** 深色主值 */
  valueMain: string
  /** 浅色部分（单位 / 副值，如 "k" "/20 辆" " 单"） */
  valueLight: string
  icon: string
  /** 图标色调 */
  tone: 'blue' | 'green' | 'orange' | 'red'
  /** 趋势徽章文案 */
  trend: string
  /** 趋势徽章色调 */
  trendTone: 'up' | 'flat' | 'warn'
}

export const dashStats: DashStat[] = [
  { key: 'revenue', label: '本月营收', valueMain: '¥0.0', valueLight: 'k', icon: 'Money', tone: 'blue', trend: '实时', trendTone: 'flat' },
  { key: 'renting', label: '在租车辆', valueMain: '0', valueLight: '/0 辆', icon: 'Van', tone: 'green', trend: '利用率 0%', trendTone: 'flat' },
  { key: 'orders', label: '本月订单', valueMain: '0', valueLight: ' 单', icon: 'Tickets', tone: 'orange', trend: '实时', trendTone: 'flat' },
  { key: 'violation', label: '待处理违章', valueMain: '0', valueLight: ' 起', icon: 'Warning', tone: 'red', trend: '需关注', trendTone: 'warn' },
]

export const weeklyRevenue: { day: string; value: number }[] = [
  { day: '—', value: 0 },
]

export const fleetStatus: { name: string; value: number; color: string }[] = [
  { name: '未租', value: 0, color: '#3B83F5' },
  { name: '已租', value: 0, color: '#22b07d' },
  { name: '维保', value: 0, color: '#f5a623' },
  { name: '自用', value: 0, color: '#9b5de5' },
]

export const fleetTotal = fleetStatus.reduce((s, f) => s + f.value, 0)

/** 进行中的租约 */
export interface ActiveLease {
  plate: string
  model: string
  customer: string
  start: string
  end: string
  progress: number // 租期进度百分比
  carInfo?: string
  mileage?: string
}

export const activeLeases: ActiveLease[] = []

/** 待办提醒 */
export interface TodoItem {
  title: string
  desc: string
  tag: string
  route?: string
  /** 圆点 + 标签色调 */
  tone: 'danger' | 'warning' | 'primary' | 'purple' | 'success'
}

export const todoItems: TodoItem[] = []
