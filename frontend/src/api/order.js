import requestHttp from '@/utils/request'

export default {
  // 创建订单
  async save(data) {
    return await requestHttp.post('/rental/order', data)
  },
  // 查询未归还订单
  async searchUnfinished(start, size, data) {
    return await requestHttp.post(`/rental/order/unfinished/${start}/${size}`, data)
  },
  // 归还（更新订单）
  async update(data) {
    return await requestHttp.put('/rental/order', data)
  },
  // 订单详情分页查询（全部订单）
  async search(start, size, data) {
    return await requestHttp.post(`/rental/order/${start}/${size}`, data)
  },
  // 统计该车在订单租期内是否有未处理违章
  async countViolation(autoId) {
    return await requestHttp.get(`/rental/order/countViolation/${autoId}`)
  },
  // 执行押金返还
  async doReturnDeposit(orderId) {
    return await requestHttp.get(`/rental/order/doReturnDeposit/${orderId}`)
  }
}
