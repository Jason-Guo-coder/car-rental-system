import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { RentalOrder } from '@/types'

type OrderQuery = Partial<RentalOrder> & { page?: number; size?: number }

/** 订单 store（订单总览 + 车辆归还共用） */
export const useOrderStore = defineStore('order', {
  state: () => ({
    list: [] as RentalOrder[],
    statsList: [] as RentalOrder[],
    returnList: [] as RentalOrder[],
    totalCount: 0,
    statsTotal: 0,
    returnTotal: 0,
    query: { page: 1, size: 5 } as OrderQuery,
    returnQuery: { page: 1, size: 5 } as OrderQuery,
    loading: false,
  }),
  getters: {
    total: (s) => s.totalCount || s.list.length,
    overviewTotal: (s) => s.statsTotal || s.statsList.length,
    rentingCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((o) => o.status === 'renting').length,
    returnedCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((o) => o.status === 'returned').length,
    overdueCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((o) => o.status === 'overdue').length,
    depositPendingCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((o) => o.returnTime && o.depositReturn === 0).length,
    totalAmount: (s) => (s.statsList.length ? s.statsList : s.list).reduce((sum, o) => sum + o.amount, 0),
    /** 进行中订单（车辆归还页用） */
    active: (s) => s.list.filter((o) => o.status === 'renting' || o.status === 'overdue'),
  },
  actions: {
    async load() {
      this.loading = true
      try {
        await this.searchOrders()
      } finally {
        this.loading = false
      }
    },
    async searchOrders(query: OrderQuery = {}) {
      this.query = { ...this.query, ...query }
      const result = await api.orders.search(this.query)
      this.list = result.list
      this.totalCount = result.total
      await this.loadOrderStats()
    },
    async loadOrderStats() {
      const first = await api.orders.search({ page: 1, size: 999 })
      this.statsTotal = first.total
      if (!first.total) {
        this.statsList = []
        return
      }
      this.statsList = first.total > first.list.length ? (await api.orders.search({ page: 1, size: first.total })).list : first.list
    },
    async searchUnfinished(query: OrderQuery = {}) {
      this.returnQuery = { ...this.returnQuery, ...query }
      const result = await api.orders.unfinished(this.returnQuery)
      this.returnList = result.list
      this.returnTotal = result.total
    },
    async rentCar(payload: { autoId: number; customerId: number; typeId: number; rent: number; deposit: number; mileage: number }) {
      await api.orders.save(payload)
      await this.load()
    },
    /** 办理归还：登记归还里程/时间与实付金额，状态置为已归还 */
    async returnCar(id: number, payload: { returnMileage: number; returnTime: string; payable: number; paid: number }) {
      const o = this.returnList.find((x) => x.id === id) ?? this.list.find((x) => x.id === id)
      if (!o) return
      await api.orders.update({
        ...o,
        returnMileage: payload.returnMileage,
        returnTime: payload.returnTime,
        amount: payload.payable,
        paid: payload.paid,
      })
      await this.searchUnfinished()
      await this.load()
    },
    async countViolation(autoId: number) {
      return api.orders.countViolation(autoId)
    },
    async returnDeposit(id: number) {
      await api.orders.returnDeposit(id)
      await this.searchOrders()
    },
  },
})
