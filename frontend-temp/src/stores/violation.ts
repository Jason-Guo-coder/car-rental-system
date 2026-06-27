import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Violation } from '@/types'

type ViolationQuery = Partial<Violation> & {
  fineMin?: number
  fineMax?: number
  lowViolationTime?: string
  highViolationTime?: string
}

export const useViolationStore = defineStore('violation', {
  state: () => ({
    list: [] as Violation[],
    loading: false,
  }),
  getters: {
    pendingCount: (s) => s.list.filter((v) => v.status === 'pending').length,
  },
  actions: {
    async load(query: ViolationQuery = {}) {
      this.loading = true
      try {
        this.list = await api.violations.search(query)
      } finally {
        this.loading = false
      }
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
