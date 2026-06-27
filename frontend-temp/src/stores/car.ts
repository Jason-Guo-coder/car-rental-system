import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { CarInfo } from '@/types'

type CarQuery = Partial<CarInfo> & { page?: number; size?: number; rentMin?: number; rentMax?: number; lowRegistrationDate?: string; highRegistrationDate?: string }

/** 车辆信息 store —— 视图层只从这里取数与操作，不直接 import 数据文件 */
export const useCarStore = defineStore('car', {
  state: () => ({
    list: [] as CarInfo[],
    loading: false,
  }),
  getters: {
    total: (s) => s.list.length,
    idleCount: (s) => s.list.filter((c) => c.status === 'idle').length,
    rentingCount: (s) => s.list.filter((c) => c.status === 'renting').length,
    maintainCount: (s) => s.list.filter((c) => c.status === 'maintain').length,
    /** 可租车辆（汽车出租页用） */
    rentable: (s) => s.list.filter((c) => c.status === 'idle'),
  },
  actions: {
    async load() {
      this.loading = true
      try {
        this.list = await api.cars.search()
      } finally {
        this.loading = false
      }
    },
    async search(query: CarQuery = {}) {
      this.loading = true
      try {
        this.list = await api.cars.search(query)
      } finally {
        this.loading = false
      }
    },
    async add(car: Omit<CarInfo, 'id'>) {
      await api.cars.save(car)
      await this.load()
    },
    async update(car: CarInfo) {
      await api.cars.update(car)
      await this.load()
    },
    async remove(id: number) {
      await api.cars.delete([id])
      await this.load()
    },
    async removeMany(ids: number[]) {
      await api.cars.delete(ids)
      await this.load()
    },
  },
})
