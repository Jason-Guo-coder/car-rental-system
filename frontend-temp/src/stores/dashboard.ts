import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import {
  dashStats,
  weeklyRevenue,
  fleetStatus,
  fleetTotal,
  activeLeases,
  todoItems,
} from '@/data/dashboard'
import type { Maintain, RentalOrder } from '@/types'

type FinanceMonth = { month: string; revenue: number; cost: number; orders: number }
type FinanceType = { value: number; name: string; itemStyle: { color: string } }

const typeColors = ['#5b8def', '#22b07d', '#f5a623', '#9b5de5', '#10b3a3', '#f97316']

function parseYearMonth(value?: string) {
  const match = value?.match?.(/^(\d{4})-(\d{1,2})/)
  if (!match) return null
  return { year: Number(match[1]), month: Number(match[2]) }
}

function buildFinanceReport(orders: RentalOrder[], maintains: Maintain[]) {
  const year = new Date().getFullYear()
  const monthly: FinanceMonth[] = Array.from({ length: 12 }, (_, i) => ({
    month: `${i + 1}月`,
    revenue: 0,
    cost: 0,
    orders: 0,
  }))
  const byType = new Map<string, number>()

  for (const order of orders) {
    const rentalMonth = parseYearMonth(order.startDate)
    if (rentalMonth?.year === year) monthly[rentalMonth.month - 1].orders += 1

    const returnMonth = parseYearMonth(order.returnTime)
    if (returnMonth?.year !== year) continue

    const revenue = Number(order.paid ?? 0)
    monthly[returnMonth.month - 1].revenue += revenue
    if (revenue > 0) {
      const typeName = order.rentalType || '未知类型'
      byType.set(typeName, (byType.get(typeName) ?? 0) + revenue)
    }
  }

  for (const maintain of maintains) {
    const maintainMonth = parseYearMonth(maintain.time)
    if (maintainMonth?.year === year) monthly[maintainMonth.month - 1].cost += Number(maintain.cost ?? 0)
  }

  const financeByType: FinanceType[] = Array.from(byType.entries()).map(([name, value], index) => ({
    name,
    value,
    itemStyle: { color: typeColors[index % typeColors.length] },
  }))

  if (!financeByType.length) {
    financeByType.push({ value: 0, name: '暂无收入', itemStyle: { color: '#c9cdd9' } })
  }

  return { monthly, byType: financeByType }
}

async function loadAllOrders() {
  const first = await api.orders.search({ page: 1, size: 999 })
  if (first.total > first.list.length) return (await api.orders.search({ page: 1, size: first.total })).list
  return first.list
}

async function loadAllMaintains() {
  const first = await api.maintains.searchPage({ page: 1, size: 999 })
  if (first.total > first.list.length) return (await api.maintains.searchPage({ page: 1, size: first.total })).list
  return first.list
}

/** 首页仪表盘 store —— 聚合各类展示数据，视图只从这里取 */
export const useDashboardStore = defineStore('dashboard', {
  state: () => ({
    stats: [...dashStats],
    weeklyRevenue: [...weeklyRevenue],
    fleetStatus: [...fleetStatus],
    fleetTotal,
    activeLeases: [...activeLeases],
    todos: [...todoItems],
    financeMonthly: [] as { month: string; revenue: number; cost: number; orders: number }[],
    financeByType: [] as { value: number; name: string; itemStyle: { color: string } }[],
    loading: false,
  }),
  actions: {
    async loadFinanceReport() {
      const [orders, maintains] = await Promise.all([loadAllOrders(), loadAllMaintains()])
      const report = buildFinanceReport(orders, maintains)
      this.financeMonthly = report.monthly
      this.financeByType = report.byType
    },
    async load() {
      this.loading = true
      try {
        const overview = await api.dashboard.overview().catch(() => null)
        if (overview) {
          this.stats = overview.stats ?? this.stats
          this.weeklyRevenue = overview.weeklyRevenue ?? this.weeklyRevenue
          this.fleetStatus = overview.fleetStatus ?? this.fleetStatus
          this.fleetTotal = overview.fleetTotal ?? this.fleetTotal
          this.activeLeases = overview.activeLeases ?? this.activeLeases
          this.todos = overview.todos ?? this.todos
          await this.loadFinanceReport()
          return
        }

        const [cars, orders, violations, maintains] = await Promise.all([
          api.cars.search(),
          loadAllOrders(),
          api.violations.search(),
          loadAllMaintains(),
        ])
        const renting = cars.filter((c) => c.status === 'renting').length
        const now = new Date()
        const monthRevenue = orders.reduce((sum, order) => {
          const returned = parseYearMonth(order.returnTime)
          return returned?.year === now.getFullYear() && returned.month === now.getMonth() + 1 ? sum + Number(order.paid ?? 0) : sum
        }, 0)
        const monthOrders = orders.filter((order) => {
          const rented = parseYearMonth(order.startDate)
          return rented?.year === now.getFullYear() && rented.month === now.getMonth() + 1
        }).length
        this.fleetStatus = [
          { name: '未租', value: cars.filter((c) => c.status === 'idle').length, color: '#3B83F5' },
          { name: '已租', value: renting, color: '#22b07d' },
          { name: '维保', value: cars.filter((c) => c.status === 'maintain').length, color: '#f5a623' },
          { name: '自用', value: cars.filter((c) => c.status === 'selfUse').length, color: '#9b5de5' },
        ]
        this.fleetTotal = cars.length
        this.activeLeases = orders.filter((o) => o.status === 'renting').slice(0, 4).map((o) => ({
          plate: o.plateNo,
          model: o.rentalType,
          customer: o.customerName,
          start: o.startDate.slice(5, 10),
          end: o.endDate?.slice(5, 10) || '-',
          progress: 30,
        }))
        this.todos = violations.filter((v) => v.status === 'pending').slice(0, 5).map((v) => ({
          title: '违章待处理',
          desc: `${v.plateNo} ${v.reason} 罚款¥${v.fine}`,
          tag: '待处理',
          tone: 'danger' as const,
        }))
        this.stats = [
          { key: 'revenue', label: '本月营收', valueMain: `¥${(monthRevenue / 1000).toFixed(1)}`, valueLight: 'k', icon: 'Money', tone: 'blue', trend: '实时', trendTone: 'flat' },
          { key: 'renting', label: '在租车辆', valueMain: String(renting), valueLight: `/${cars.length} 辆`, icon: 'Van', tone: 'green', trend: cars.length ? `利用率 ${Math.round((renting / cars.length) * 100)}%` : '利用率 0%', trendTone: 'flat' },
          { key: 'orders', label: '本月订单', valueMain: String(monthOrders), valueLight: ' 单', icon: 'Tickets', tone: 'orange', trend: '实时', trendTone: 'flat' },
          { key: 'violation', label: '待处理违章', valueMain: String(violations.filter((v) => v.status === 'pending').length), valueLight: ' 起', icon: 'Warning', tone: 'red', trend: '需关注', trendTone: 'warn' },
        ]
        const financeReport = buildFinanceReport(orders, maintains)
        this.financeMonthly = financeReport.monthly
        this.financeByType = financeReport.byType
      } finally {
        this.loading = false
      }
    },
  },
})
