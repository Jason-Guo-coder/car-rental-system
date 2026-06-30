import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { RentalType } from '@/types'

type RentalTypeQuery = Partial<RentalType> & { page?: number; size?: number; discountMin?: number; discountMax?: number }

export const useRentalTypeStore = defineStore('rentalType', {
  state: () => ({
    list: [] as RentalType[],
    totalCount: 0,
    query: { page: 1, size: 5 } as RentalTypeQuery,
    loading: false,
  }),
  actions: {
    async load() {
      this.loading = true
      try {
        await this.search()
      } finally {
        this.loading = false
      }
    },
    async search(query: RentalTypeQuery = {}) {
      this.query = { ...this.query, ...query }
      this.loading = true
      try {
        const result = await api.rentalTypes.searchPage(this.query)
        this.list = result.list
        this.totalCount = result.total
      } finally {
        this.loading = false
      }
    },
    async add(t: Omit<RentalType, 'id'>) {
      await api.rentalTypes.save(t)
      await this.load()
    },
    async update(t: RentalType) {
      await api.rentalTypes.update(t)
      await this.load()
    },
    async remove(id: number) {
      await api.rentalTypes.delete([id])
      await this.load()
    },
    async removeMany(ids: number[]) {
      await api.rentalTypes.delete(ids)
      await this.load()
    },
  },
})
