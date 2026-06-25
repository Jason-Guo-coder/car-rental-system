import requestHttp from '@/utils/request'

export default {
  // 日报：当日收入
  async countDayCost() {
    return await requestHttp.get('/rental/finance/countDayCost')
  },
  // 日报：各小时出租数量
  async countDayRental() {
    return await requestHttp.get('/rental/finance/countDayRental')
  },
  // 日报：各小时归还数量
  async countDayReturn() {
    return await requestHttp.get('/rental/finance/countDayReturn')
  },
  // 月报：当月收入
  async countMonthCost() {
    return await requestHttp.get('/rental/finance/countMonthCost')
  },
  // 月报：各天出租数量
  async countMonthRental() {
    return await requestHttp.get('/rental/finance/countMonthRental')
  },
  // 月报：各天归还数量
  async countMonthReturn() {
    return await requestHttp.get('/rental/finance/countMonthReturn')
  }
}
