import { defineStore } from 'pinia'
import { api } from '@/api/backend'
import type { Maker, Brand } from '@/types'

/** 厂商 + 品牌 store */
export const useMakerStore = defineStore('maker', {
  state: () => ({
    makers: [] as Maker[],
    brands: [] as Brand[],
    activeBrands: [] as Brand[],
    activeMakerId: 0,
    loading: false,
  }),
  getters: {
    /** 当前选中厂商下的品牌 */
    brandsOfActive(state): Brand[] {
      return state.activeBrands
    },
  },
  actions: {
    async load() {
      this.loading = true
      try {
        const [makers, brands] = await Promise.all([api.makers.all(), api.brands.search()])
        const counts = brands.reduce<Record<number, number>>((acc, b) => {
          acc[b.makerId] = (acc[b.makerId] || 0) + 1
          return acc
        }, {})
        this.makers = makers.map((m) => ({ ...m, brandCount: counts[m.id] || 0 }))
        this.brands = brands.map((b) => ({ ...b, makerName: b.makerName || makers.find((m) => m.id === b.makerId)?.name || '' }))
        if (!this.activeMakerId) this.activeMakerId = this.makers[0]?.id ?? 0
        await this.searchBrands()
      } finally {
        this.loading = false
      }
    },
    async selectMaker(id: number, keyword = '') {
      this.activeMakerId = id
      await this.searchBrands(keyword)
    },
    async searchBrands(keyword = '') {
      if (!this.activeMakerId) {
        this.activeBrands = []
        return
      }
      const brands = await api.brands.search({ makerId: this.activeMakerId, name: keyword.trim() })
      this.activeBrands = brands.map((b) => ({ ...b, makerName: b.makerName || this.makers.find((m) => m.id === b.makerId)?.name || '' }))
    },
    async addMaker(name: string, country: string, logo: string, orderLetter = '') {
      void country; void logo
      await api.makers.save({ name, orderLetter })
      await this.load()
    },
    async addBrand(makerId: number, name: string) {
      await api.brands.save({ makerId, name })
      await this.load()
    },
    async updateMaker(id: number, name: string, orderLetter = '') {
      await api.makers.update({ id, name, orderLetter })
      await this.load()
    },
    async updateBrand(id: number, makerId: number, name: string) {
      await api.brands.update({ id, makerId, name })
      await this.load()
    },
    async removeMaker(id: number) {
      await api.makers.delete([id])
      await this.load()
    },
    async removeManyMakers(ids: number[]) {
      await api.makers.delete(ids)
      await this.load()
    },
    async removeBrand(id: number) {
      await api.brands.delete([id])
      await this.load()
    },
    async removeManyBrands(ids: number[]) {
      await api.brands.delete(ids)
      await this.load()
    },
  },
})
