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
  { key: 'revenue', label: '本月营收', valueMain: '¥128.6', valueLight: 'k', icon: 'Money', tone: 'blue', trend: '↑ 12.5%', trendTone: 'up' },
  { key: 'renting', label: '在租车辆', valueMain: '5', valueLight: '/20 辆', icon: 'Van', tone: 'green', trend: '利用率 25%', trendTone: 'flat' },
  { key: 'orders', label: '本月订单', valueMain: '28', valueLight: ' 单', icon: 'Tickets', tone: 'orange', trend: '↑ 8.3%', trendTone: 'up' },
  { key: 'violation', label: '待处理违章', valueMain: '3', valueLight: ' 起', icon: 'Warning', tone: 'red', trend: '需关注', trendTone: 'warn' },
]

/** 近 7 日营收（单位：千元），合计约 128.6k */
export const weeklyRevenue: { day: string; value: number }[] = [
  { day: '周一', value: 16.2 },
  { day: '周二', value: 18.5 },
  { day: '周三', value: 15.8 },
  { day: '周四', value: 22.4 },
  { day: '周五', value: 19.6 },
  { day: '周六', value: 17.5 },
  { day: '周日', value: 18.6 },
]

/** 车队状态构成（合计 20 辆） */
export const fleetStatus: { name: string; value: number; color: string }[] = [
  { name: '未租', value: 13, color: '#3B83F5' },
  { name: '已租', value: 5, color: '#22b07d' },
  { name: '维保', value: 1, color: '#f5a623' },
  { name: '自用', value: 1, color: '#9b5de5' },
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
}

export const activeLeases: ActiveLease[] = [
  { plate: '沪A8K233', model: '凯美瑞', customer: '吴志强', start: '6-25', end: '6-28', progress: 62 },
  { plate: '沪A8K235', model: '君威', customer: '郑国平', start: '6-25', end: '6-27', progress: 45 },
  { plate: '沪A8K240', model: '宝马3系', customer: '马文斌', start: '6-25', end: '7-02', progress: 18 },
  { plate: '沪A8K242', model: '奔驰C级', customer: '罗永强', start: '6-25', end: '6-30', progress: 30 },
]

/** 待办提醒 */
export interface TodoItem {
  title: string
  desc: string
  tag: string
  /** 圆点 + 标签色调 */
  tone: 'danger' | 'warning' | 'primary' | 'purple' | 'success'
}

export const todoItems: TodoItem[] = [
  { title: '违章待处理', desc: '沪A8K247 超速50% 罚款¥1000', tag: '紧急', tone: 'danger' },
  { title: '即将到期归还', desc: '沪A8K233 凯美瑞·还剩 1 天', tag: '今日', tone: 'warning' },
  { title: '待保养车辆', desc: '沪A8K236 凯美瑞·应保 > 实保', tag: '提醒', tone: 'primary' },
  { title: '黑名单客户', desc: '林晓梅·存在未结违章', tag: '关注', tone: 'purple' },
  { title: '新增订单', desc: '马文斌 租赁宝马3系 7 天', tag: '刚刚', tone: 'success' },
]
