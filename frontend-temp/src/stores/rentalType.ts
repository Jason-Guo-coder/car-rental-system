import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { RentalType } from '@/types'

export const useRentalTypeStore = defineStore('rentalType', {
  state: () => ({
    list: [] as RentalType[],
    loading: false,
  }),
  actions: {
    async load() {
      this.loading = true
      try {
        this.list = await api.rentalTypes.all()
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
