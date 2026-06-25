import requestHttp from '@/utils/request'

export default {
  async search(start, size, data) {
    return await requestHttp.post(`/rental/rentalType/${start}/${size}`, data)
  },
  async save(data) {
    return await requestHttp.post('/rental/rentalType', data)
  },
  async update(data) {
    return await requestHttp.put('/rental/rentalType', data)
  },
  async delete(ids) {
    return await requestHttp.delete(`/rental/rentalType/${ids}`)
  },
  // 查询所有出租类型（出租下拉用）
  async selectAll() {
    return await requestHttp.get('/rental/rentalType')
  }
}
