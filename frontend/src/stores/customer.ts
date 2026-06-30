import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Customer } from '@/types'

type CustomerQuery = Partial<Customer> & { page?: number; size?: number; ageMin?: number; ageMax?: number }

export const useCustomerStore = defineStore('customer', {
  state: () => ({
    list: [] as Customer[],
    statsList: [] as Customer[],
    totalCount: 0,
    statsTotal: 0,
    query: { page: 1, size: 5 } as CustomerQuery,
    loading: false,
  }),
  getters: {
    total: (s) => s.totalCount || s.list.length,
    overviewTotal: (s) => s.statsTotal || s.statsList.length,
    whiteCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((c) => c.listType === 'white').length,
    blackCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((c) => c.listType === 'black').length,
  },
  actions: {
    async load() {
      this.loading = true
      try {
        await this.search()
      } finally {
        this.loading = false
      }
    },
    async search(query: CustomerQuery = {}) {
      this.query = { ...this.query, ...query }
      this.loading = true
      try {
        const result = await api.customers.searchPage(this.query)
        this.list = result.list
        this.totalCount = result.total
        await this.loadStats()
      } finally {
        this.loading = false
      }
    },
    async loadStats() {
      const first = await api.customers.searchPage({ page: 1, size: 999 })
      this.statsTotal = first.total
      if (!first.total) {
        this.statsList = []
        return
      }
      this.statsList = first.total > first.list.length ? (await api.customers.searchPage({ page: 1, size: first.total })).list : first.list
    },
    async byPhone(phone: string) {
      return api.customers.byPhone(phone)
    },
    async add(c: Omit<Customer, 'id'>) {
      const id = await api.customers.save(c)
      await this.load()
      return id
    },
    async update(c: Customer) {
      await api.customers.update(c)
      await this.load()
    },
    async remove(id: number) {
      await api.customers.delete([id])
      await this.load()
    },
    async removeMany(ids: number[]) {
      await api.customers.delete(ids)
      await this.load()
    },
  },
})
