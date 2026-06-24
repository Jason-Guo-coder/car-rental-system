import requestHttp from '@/utils/request'

export default {
  async search(params) {
    return await requestHttp.post('/rental/dept', params)
  },
  async selectTree() {
    return await requestHttp.get('/rental/dept')
  },
  async save(data) {
    return await requestHttp.post('/rental/dept/save', data)
  },
  async update(data) {
    return await requestHttp.put('/rental/dept', data)
  },
  async hasChildren(id) {
    return await requestHttp.get(`/rental/dept/${id}`)
  },
  async delete(id) {
    return await requestHttp.delete(`/rental/dept/${id}`)
  }
}
