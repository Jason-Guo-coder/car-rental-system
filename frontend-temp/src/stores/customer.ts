import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Customer } from '@/types'

type CustomerQuery = Partial<Customer> & { page?: number; size?: number; ageMin?: number; ageMax?: number }

export const useCustomerStore = defineStore('customer', {
  state: () => ({
    list: [] as Customer[],
    loading: false,
  }),
  getters: {
    total: (s) => s.list.length,
    whiteCount: (s) => s.list.filter((c) => c.listType === 'white').length,
    blackCount: (s) => s.list.filter((c) => c.listType === 'black').length,
  },
  actions: {
    async load() {
      this.loading = true
      try {
        this.list = await api.customers.search()
      } finally {
        this.loading = false
      }
    },
    async search(query: CustomerQuery = {}) {
      this.loading = true
      try {
        this.list = await api.customers.search(query)
      } finally {
        this.loading = false
      }
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
