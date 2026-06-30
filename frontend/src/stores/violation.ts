import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Violation } from '@/types'

type ViolationQuery = Partial<Violation> & {
  page?: number
  size?: number
  fineMin?: number
  fineMax?: number
  lowViolationTime?: string
  highViolationTime?: string
}

export const useViolationStore = defineStore('violation', {
  state: () => ({
    list: [] as Violation[],
    statsList: [] as Violation[],
    totalCount: 0,
    statsTotal: 0,
    query: { page: 1, size: 5 } as ViolationQuery,
    loading: false,
  }),
  getters: {
    overviewTotal: (s) => s.statsTotal || s.statsList.length,
    pendingCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((v) => v.status === 'pending').length,
    totalFine: (s) => (s.statsList.length ? s.statsList : s.list).reduce((sum, v) => sum + v.fine, 0),
  },
  actions: {
    async load(query: ViolationQuery = {}) {
      this.query = { ...this.query, ...query }
      this.loading = true
      try {
        const result = await api.violations.searchPage(this.query)
        this.list = result.list
        this.totalCount = result.total
        await this.loadStats()
      } finally {
        this.loading = false
      }
    },
    async loadStats() {
      const first = await api.violations.searchPage({ page: 1, size: 999 })
      this.statsTotal = first.total
      if (!first.total) {
        this.statsList = []
        return
      }
      this.statsList = first.total > first.list.length ? (await api.violations.searchPage({ page: 1, size: first.total })).list : first.list
    },
    async add(v: Omit<Violation, 'id'>) {
      await api.violations.save(v)
      await this.load()
    },
    async update(v: Violation) {
      await api.violations.update(v)
      await this.load()
    },
    async handle(id: number) {
      const v = this.list.find((x) => x.id === id)
      if (!v) return
      await api.violations.update({ ...v, status: 'handled' })
      await this.load()
    },
    async remove(id: number) {
      await api.violations.delete([id])
      await this.load()
    },
    async removeMany(ids: number[]) {
      await api.violations.delete(ids)
      await this.load()
    },
  },
})
