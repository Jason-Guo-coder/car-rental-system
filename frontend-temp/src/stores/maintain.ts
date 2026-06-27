import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Maintain } from '@/types'

export const useMaintainStore = defineStore('maintain', {
  state: () => ({
    list: [] as Maintain[],
    loading: false,
  }),
  getters: {
    pendingCount: (s) => s.list.filter((m) => m.status === 'pending').length,
  },
  actions: {
    async load() {
      this.loading = true
      try {
        this.list = await api.maintains.search()
      } finally {
        this.loading = false
      }
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
