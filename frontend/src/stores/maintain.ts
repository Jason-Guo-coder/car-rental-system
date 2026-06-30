import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Maintain } from '@/types'

type MaintainQuery = Partial<Maintain> & { page?: number; size?: number; costMin?: number; costMax?: number; lowMaintainTime?: string; highMaintainTime?: string }

export const useMaintainStore = defineStore('maintain', {
  state: () => ({
    list: [] as Maintain[],
    statsList: [] as Maintain[],
    totalCount: 0,
    statsTotal: 0,
    query: { page: 1, size: 5 } as MaintainQuery,
    loading: false,
  }),
  getters: {
    overviewTotal: (s) => s.statsTotal || s.statsList.length,
    pendingCount: (s) => (s.statsList.length ? s.statsList : s.list).filter((m) => m.status === 'pending').length,
    totalCost: (s) => (s.statsList.length ? s.statsList : s.list).reduce((sum, m) => sum + m.cost, 0),
  },
  actions: {
    async load(query: MaintainQuery = {}) {
      this.query = { ...this.query, ...query }
      this.loading = true
      try {
        const result = await api.maintains.searchPage(this.query)
        this.list = result.list
        this.totalCount = result.total
        await this.loadStats()
      } finally {
        this.loading = false
      }
    },
    async loadStats() {
      const first = await api.maintains.searchPage({ page: 1, size: 999 })
      this.statsTotal = first.total
      if (!first.total) {
        this.statsList = []
        return
      }
      this.statsList = first.total > first.list.length ? (await api.maintains.searchPage({ page: 1, size: first.total })).list : first.list
    },
    async add(m: Omit<Maintain, 'id'>) {
      await api.maintains.save(m)
      await this.load()
    },
    async update(m: Maintain) {
      await api.maintains.update(m)
      await this.load()
    },
    async finish(id: number) {
      const m = this.list.find((x) => x.id === id)
      if (!m) return
      await api.maintains.update(m)
      await this.load()
    },
    async remove(id: number) {
      await api.maintains.delete([id])
      await this.load()
    },
    async removeMany(ids: number[]) {
      await api.maintains.delete(ids)
      await this.load()
    },
  },
})
